Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2CWJTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 05:19:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:44302 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2CWJTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 05:19:45 -0400
Date: Fri, 23 Mar 2012 10:19:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Shiyan <shc_work@mail.ru>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re[2]: [PATCH] Fix build error with !SMP && !GENERIC_HARDIRQS
In-Reply-To: <E1SAzcK-0001aj-CS.shc_work-mail-ru@f287.mail.ru>
Message-ID: <alpine.LFD.2.02.1203231018010.2542@ionos>
References: <1332487384-13803-1-git-send-email-shc_work@mail.ru> <CAMuHMdXoJhWVoRrhgYzVcv3tbThzmtiZ4ZY6pjUM2eji5XuK2A@mail.gmail.com> <E1SAzcK-0001aj-CS.shc_work-mail-ru@f287.mail.ru>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1348824207-1332494382=:2542"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1348824207-1332494382=:2542
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 23 Mar 2012, Alexander Shiyan wrote:

> Fri, 23 Mar 2012 08:46:15 +0100 от Geert Uytterhoeven <geert@linux-m68k.org>:
> > On Fri, Mar 23, 2012 at 08:23, Alexander Shiyan <shc_work@mail.ru> wrote:
> > > When compile kernel with !SMP && !GENERIC_HARDIRQS we are have
> > > following error:
> > Is this on uniprocessor s390?
> No. I trying to fix other problem with ARM Cirrus Logic EP7312 that do not work since 2.6.30-rc1.
> The problem appear after commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=c61b79b6ef266890954213a701d8f6021d8c1289
> 
> I just playing with this commit and found this compile error.

Which was probably caused by you playing with that commit.

Again arch/arm has GENERIC_HARDIRQS=y and therefor the problem does
not exist. For GENERIC_HARDIRQS=n that file is not compiled.

Ergo: -ENOPROBLEM

Thanks,

	tglx
--8323328-1348824207-1332494382=:2542--
