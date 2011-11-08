Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab1KHBXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:23:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63464 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1KHBXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:23:49 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=D3TyVVOW3vgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=Tdy1bQSPYYFkBLt8PykA:9 a=tNr4RAStwLt-DVfEZ6QA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320715426.26400.5.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/21] [GIT PULL] ktest: lots of nice new features
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 07 Nov 2011 20:23:46 -0500
In-Reply-To: <20111028111558.173726794@goodmis.org>
References: <20111028111558.173726794@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 07:15 -0400, Steven Rostedt wrote:
> Linus,
> 
> This is the udates I have done since the last merge window. Some included fixes
> I needed to present my tutorial at LinuxCon. My tutorial was based on the feature
> set added by this patch pull.
> 
> Please pull the following patch set:
> 
> HEAD SHA1: 815e2bd7d609da9c7615ea28a3990064a394312f


Hi Linus,

I noticed the merge window closed and this pull request didn't make it.
Was there an issue with it, or did it just get lost in the noise?

Thanks,

-- Steve



> 
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
> 
>     branch: for-linus
> 
> 
> Andrew Jones (3):
>       ktest: Create outputdir if it does not exist
>       ktest: Only need to save .config when doing mrproper
>       ktest: Include monitor in reboot code
> 
> Steven Rostedt (18):
>       ktest: Add TEST_TYPE install option
>       ktest: Fail when grub menu not found
>       ktest: Add NO_INSTALL option to not install for a test
>       ktest: Add option REBOOT_SUCCESS_LINE to stop waiting after a reboot
>       ktest: Do not reboot on config or build issues
>       ktest: Add IF and ELSE to config sections
>       ktest: Let IF keyword take comparisons
>       ktest: Add INCLUDE keyword to include other config files
>       ktest: Consolidate TEST_TYPE and DEFAULT code
>       ktest: Add OVERRIDE keyword to DEFAULTS section
>       ktest: Add DEFINED keyword for IF statements
>       ktest: Sort make_min_config configs by dependecies
>       ktest: Fix parsing of config section lines
>       ktest: Add processing of complex conditionals
>       ktest: Do not opencode reboot in grub setting
>       ktest: Add another monitor flush before installing kernel
>       ktest: Add variable ${PWD}
>       ktest: Evaluate variables entered on the command line
> 
> ----
>  tools/testing/ktest/ktest.pl    |  515 +++++++++++++++++++++++++++++++--------
>  tools/testing/ktest/sample.conf |  146 +++++++++++-
>  2 files changed, 553 insertions(+), 108 deletions(-)


