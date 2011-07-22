Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab1GVVQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:16:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:42504 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab1GVVQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:16:14 -0400
Date: Fri, 22 Jul 2011 23:16:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kim Leyendecker <kimleyendecker@hotmail.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt1
In-Reply-To: <BLU0-SMTP162767710C410F235B35D6A54E0@phx.gbl>
Message-ID: <alpine.LFD.2.02.1107222307040.2702@ionos>
References: <alpine.LFD.2.02.1107222203400.2702@ionos> <BLU0-SMTP162767710C410F235B35D6A54E0@phx.gbl>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1073585759-1311369373=:2702"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1073585759-1311369373=:2702
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 22 Jul 2011, Kim Leyendecker wrote:

> Am 22.07.2011 22:37, schrieb Thomas Gleixner:
> > Patch against 3.0 can be found here:
> > 
> >    http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0-rt1.patch.bz2
> 
> Have you tested the file? I downloaded it and Kompare told me, that it can´t
> read the out put of the diff file.

Blame Kompare :)
 
# cd linux
# wget http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0-rt1.patch.bz2
# bunzip2 patch-3.0-rt1.patch.bz2 
# patch -p1 <patch-3.0-rt1.patch

> Maybe you should try it again?

Maybe not :)

Thanks,

	tglx
--8323328-1073585759-1311369373=:2702--
