Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab1INS6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:58:47 -0400
Received: from lucidpixels.com ([72.73.18.11]:55646 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519Ab1INS6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:58:47 -0400
Date: Wed, 14 Sep 2011 14:58:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Lin Ming <mlin@ss.pku.edu.cn>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        Andrew Morton <akpm@google.com>
Subject: Re: 3.0.1: pagevec_lookup+0x1d/0x30, SLAB issues?
In-Reply-To: <alpine.DEB.2.02.1109140901560.2082@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1109141457510.2082@p34.internal.lan>
References: <alpine.DEB.2.02.1109111815520.19558@p34.internal.lan>  <alpine.DEB.2.02.1109111837200.19558@p34.internal.lan>  <CAF1ivSZQ=KKC0gAk93eMVwLSCbeEWr=k6YszuE=sb1+Ue521vw@mail.gmail.com>  <alpine.DEB.2.02.1109140543590.29782@p34.internal.lan>
 <1315995608.2361.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.02.1109140629300.29782@p34.internal.lan> <alpine.DEB.2.02.1109140901560.2082@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Hi,
>
> Been running a lot of stressful jobs and will let them continue, so far,
> no ERROR, WARN or OOPS yet.
>
> 3.1-rc4 + the three patches above seem to fix the problems (thus far).
>
> Does anyone know when the bugs were introduced into the kernel, as some/all
> of these problems also happened with 3.0.x.
>

Up for 8+ hours, no problems yet, going to keep hammering it over the next
24 hours or so and see if I can get it to fail; thus far; no issues, very
happy, the Linux kernel is working, so far :-)

Justin.

