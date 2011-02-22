Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab1BVHaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 02:30:18 -0500
Received: from pqueuea.post.tele.dk ([193.162.153.9]:39530 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab1BVHaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 02:30:16 -0500
Date: Tue, 22 Feb 2011 08:29:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@snapgear.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Steven King <sfking00@yahoo.com>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gregungerer@westnet.com.au>
Subject: Re: merge of m68knommu and m68k arch branches?
Message-ID: <20110222072951.GA24953@merkur.ravnborg.org>
References: <4D5DB83D.80205@snapgear.com> <alpine.LFD.2.00.1102212216540.2701@localhost6.localdomain6> <4D6319E0.9080907@snapgear.com> <AANLkTi=QkXK7=DQ5H1PFttTk+iug_npCsz112RYXd7BR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=QkXK7=DQ5H1PFttTk+iug_npCsz112RYXd7BR@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >
> >> Is there a plan to move m68k to the generic facilities as well ?
> 
> Moving m68k to genirq is (the next thing?) on my list...

If I succeed migrating sparc32 to genirq I hope to be of a little help here.
It looks like a bigger task to migrate m68k than it was/is to migrate sparc32.

It would be _very_ nice to get the last two architectures migrated to genirq.

	Sam
