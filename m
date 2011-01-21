Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1AUDQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 22:16:03 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:39200 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321Ab1AUDQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 22:16:01 -0500
Date: Fri, 21 Jan 2011 05:15:53 +0200
From: Felipe Balbi <balbi@ti.com>
To: John Ogness <john.ogness@linutronix.de>
Cc: balbi@ti.com, paul@pwsan.com, tony@atomide.com, r-woodruff2@ti.com,
        linux-kernel@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] omap2: fix DPLL_FREQSEL calculation
Message-ID: <20110121031553.GA2448@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <87ei8726wf.fsf@vostro.fn.ogness.net>
 <20110120111645.GB2223@legolas.emea.dhcp.ti.com>
 <8739on1wdd.fsf_-_@vostro.fn.ogness.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8739on1wdd.fsf_-_@vostro.fn.ogness.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 03:29:50PM +0100, John Ogness wrote:
> On 2011-01-20, Felipe Balbi <balbi@ti.com> wrote:
> > scripts/get_maintainer.pl would've helped you getting a better Cc
> > list. I'm adding linux-omap and lakml
> 
> Thanks.
> 
> After investigating the issue further it seems that I had it
> backwards. The value of "n" is the value to divide by, not the value
> that goes in the register. This means that it is _dpll_test_fint()
> that is doing it incorrectly. Here is a new version of the patch to
> fix the right function.

you might want to look at Documentation/SubmittingPatches before sending
these patches. If anyone applies this patch of yours the commitlog will
have all the comments you've made above. Generally, patches are
"standalone" emails, without a discussion on them, if you want to add
comments which aren't supposed to go into commit log, then do so after
the tear line (---) and before the diff --git line; that way, git will
know it must drop that part of the comments.

-- 
balbi
