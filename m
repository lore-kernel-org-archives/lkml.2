Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2HVFmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:42:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37131 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756076Ab2HVFl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:41:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19AYrMGCFNAnj8Mo0L7NR5ozvCzlGts3gOJl/h5Ww
	en7B37rh8ad344
Message-ID: <1345614110.4374.65.camel@marge.simpson.net>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
From: Mike Galbraith <efault@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Date: Wed, 22 Aug 2012 07:41:50 +0200
In-Reply-To: <20120821170254.0b10ece6@pyramind.ukuu.org.uk>
References: <1345028738.31459.82.camel@twins>
	 <502BA7DC.7060907@linux.intel.com> <1345041548.31459.90.camel@twins>
	 <502BB5A3.5000403@linux.intel.com> <1345043096.31459.106.camel@twins>
	 <502BE38D.9030405@linux.intel.com> <20120820080606.GA6931@gmail.com>
	 <20120820181651.GA737@srcf.ucam.org> <20120821094203.GB12385@gmail.com>
	 <20120821113951.GA22436@srcf.ucam.org> <20120821151910.GA5359@gmail.com>
	 <20120821170254.0b10ece6@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 17:02 +0100, Alan Cox wrote:

> I'd like to see actual numbers and evidence on a wide range of workloads
> the spread/don't spread thing is even measurable given that you've also
> got to factor in effects like completing faster and turning everything
> off. I'd *really* like to see such evidence on a laptop,which is your
> one cited case it might work.

For my dinky dual core laptop, I suspect you're right, but for a more
powerful laptop, I'd expect spread/don't to be noticeable.

Yeah, hard numbers would be nice to see.

If I had a powerful laptop, I'd kill irq balancing, and all but periodic
load balancing, and expect to see a positive result.  Dunno what fickle
electron gods would _really_ do with those prayers though.

-Mike

