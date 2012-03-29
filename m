Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab2C2N6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:58:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39647 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab2C2N6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:58:16 -0400
Message-ID: <1333029475.3402.24.camel@edumazet-laptop>
Subject: Re: [REGRESSION][PATCH] bpf_jit drops the ball on indirect negative
 mem references
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Seiffert <kaffeemonster@googlemail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, Matt Evans <matt@ozlabs.org>
Date: Thu, 29 Mar 2012 15:57:55 +0200
In-Reply-To: <4F744D58.3070009@googlemail.com>
References: <CAPwCz79wO=5zTZmCG+ePfRuEu-p_Vosi18bYZ-MVNZGOdbE3aQ@mail.gmail.com>
	  <1332965129.2325.12.camel@edumazet-glaptop>
	  <CAPwCz7_tnjq32duJSDj21LpRe5TFvGGszH4joQr1DGTjNd7GcA@mail.gmail.com>
	 <1332967172.2325.22.camel@edumazet-glaptop>
	 <4F744D58.3070009@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 29 mars 2012 à 13:54 +0200, Jan Seiffert a écrit :

> Ok, to keep the ball rolling here is a V2 with the changes you suggested:
> 
...

> I propose the following patch to fix this situation.
> Lightly tested on x86, but the powerpc asm part is prop. wrong.
> 
> 
> Signed-of-by: Jan Seiffert <kaffeemonster@googlemail.com>
> 

x86 part seems very good at first glance, I'll test it and give my
feedback soon.

Thanks !


