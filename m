Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0IRIAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 04:00:18 -0400
Received: from mailhost-h5-p1.netultra.net ([195.5.209.34]:55203 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754611Ab0IRIAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 04:00:17 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Sep 2010 04:00:17 EDT
Date: Sat, 18 Sep 2010 09:49:39 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Nix <nix@esperi.org.uk>,
        Artur Skawina <art.08.09@gmail.com>,
        John Drescher <drescherjm@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH RFC] x86: hpet: Avoid the readback penalty
Message-ID: <20100918074939.GA3275@brouette>
References: <tip-54ff7e595d763d894104d421b103a89f7becf47c@git.kernel.org>
 <alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [2010-09-15 15:11]:
> > x86: hpet: Work around hardware stupidity

> After my brain recovered from yesterdays exposure with the x86 timer
> horror, I came up with a different solution for this problem, which
> avoids the readback of the compare register completely. It works
> nicely on my affected ATI system, but needs some exposure to the other
> machines.

Comments for this different solution seemed fine, but it seems only the
first one was commited into mainline and then stable. Is this intended?


Thanks,

Damien
