Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2A0Ktg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:49:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42799 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab2A0Ktf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:49:35 -0500
Date: Fri, 27 Jan 2012 11:49:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/mce: Replace hard coded hex constants with symbolic
 defines
Message-ID: <20120127104920.GD31782@elte.hu>
References: <20120126182842.GA8630@elte.hu>
 <08dda402d60a721ac94e79efd7646b332be3e3b2.1327622761.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08dda402d60a721ac94e79efd7646b332be3e3b2.1327622761.git.tony.luck@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@intel.com> wrote:

> Magic constants like 0x0134 in code just invite questions on
> where they come from, what they mean, can they be changed?
> 
> Provide #defines for the architecturally defined MCACOD values
> with a reference to the Intel Software Developers manual which
> describes them.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> 
> Ingo: You said "ok up to 100 cols or so" ... this goes to 103.
> If this is OK, you can either apply it from here on top of the
> x86/mce branch in tip - or I can push it to the ras tree and
> send you another pull.

Yeah, looks good to me.

Thanks,

	Ingo
