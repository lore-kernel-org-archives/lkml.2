Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab0DCTUG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 15:20:06 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:41011 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002Ab0DCTUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 15:20:00 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-04.arcor-online.net 880EA33A928
Subject: Re: [Bug 12309] Large I/O operations result in slow performance
 and high iowait times
From: Thomas Pilarski <Thomas.Pilarski@arcor.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20100331002549.GB9925@khazad-dum.debian.net>
References: <bug-12309-14043@http.bugzilla.kernel.org/>
	 <201003162357.o2GNvkNF024562@demeter.kernel.org>
	 <1269935094.2481.23.camel@localhost>
	 <20100331002549.GB9925@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Apr 2010 21:19:48 +0200
Message-ID: <1270322388.26420.56.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This problem is enormous increased, while the ultra bay disc is acceded
> > with udma2 instead of udma6 (caused by another bug), 
> 
> There is a thinkpad BIOS bug that could cause that: it will not signal a
> 80-wire cable when you hot-add an HD on a PATA ultrabay.  Exists at least on
> all T4x, including the T43.

It's a SATA untrabay disk. There is a 40-wire message, but sometimes it
works and sometimes not. I could not figure out, when it does and when
not. 

> The fix is to whitelist these thinkpads for high-speed UDMA even on 40-wire
> cables.  The workaround is to add a kernel command line parameter (I forget
> which).
> 
> Does that match your udma2 instead of udma6 problem?

Thanks. I will try it. But have to finish another project first. 



