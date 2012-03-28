Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab2C1UMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:12:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45497 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab2C1UMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:12:16 -0400
Subject: Re: [PATCH] tcp: bind() use stronger condition for bind_conflict
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: Flavio Leitner <fbl@redhat.com>, Alexandru Copot <alex.mihai.c@gmail.com>,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAEnQRZD+0AQFfFCzWZCR5JR0BUxxNEsincD+_O9F0ne2Zryp_w@mail.gmail.com>
References: <1332882712-10756-1-git-send-email-alex.mihai.c@gmail.com>
	 <20120328105212.1cb8dfe5@asterix.rh>
	 <1332946113.2325.9.camel@edumazet-glaptop>
	 <CAEnQRZD+0AQFfFCzWZCR5JR0BUxxNEsincD+_O9F0ne2Zryp_w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Mar 2012 22:12:05 +0200
Message-ID: <1332965525.2325.13.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 23:08 +0300, Daniel Baluta wrote:

> Eric, Flavio, thanks a lot for your comments. We will resubmit this
> when net-next opens.
> 
> Please let us know if you have any other observations.

Some performance data would be welcomed, in the case many sockets are
already bound...

Thanks


