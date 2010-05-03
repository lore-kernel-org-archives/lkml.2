Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab0ECVjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:39:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54575 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab0ECVjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:39:44 -0400
Date: Mon, 3 May 2010 22:39:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Jonathan Corbet <corbet@lwn.net>, mgross@linux.intel.com,
       aili@codeaurora.org, dwalker@codeaurora.org, tiwai@suse.de,
       bruce.w.allan@intel.com, davidb@quicinc.com, mcgrof@gmail.com,
       pavel@ucw.cz, linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]PM QOS refresh against next-20100430
Message-ID: <20100503213919.GA18910@srcf.ucam.org>
References: <20100430212043.GA30315@linux.intel.com> <20100503103300.6330e522@bike.lwn.net> <87y6g1547o.fsf@deeprootsystems.com> <20100503104250.7605d2bc@bike.lwn.net> <87tyqo537l.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tyqo537l.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 10:01:50AM -0700, Kevin Hilman wrote:
> Jonathan Corbet <corbet@lwn.net> writes:
> > Well, shallow could mean that the state lacks the CPUIDLE_FLAG_DEEP
> > flag; that should be relatively portable.  In any case, it seems
> > more so than "if I put in a 55us latency requirement, I'll stay out
> > of C3".
> 
> I guess it depends on your goal.  Do you just want to stay out of C3
> on your current platform?  or do you want to stay out of any low-power
> state (on any platform) where you'll have a latency of > 55 usecs?

I'd say that one plausible requirement is "DMA works", with another 
being "all interrupts work" as distinguished from "wakeup interrupts 
work".

-- 
Matthew Garrett | mjg59@srcf.ucam.org
