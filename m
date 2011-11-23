Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab1KWIyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:54:15 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:34746 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1KWIyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:54:12 -0500
Date: Wed, 23 Nov 2011 10:54:10 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Keith Packard <keithp@keithp.com>
cc: David Woodhouse <dwmw2@infradead.org>, dri-devel@lists.freedesktop.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: Bisected regression: hang on i915 between 3.1.0-rc9 and 3.1.0
In-Reply-To: <86obw3e133.fsf@sumi.keithp.com>
Message-ID: <alpine.SOC.1.00.1111231053020.15939@math.ut.ee>
References: <alpine.SOC.1.00.1111221207090.6490@math.ut.ee> <alpine.SOC.1.00.1111221306410.8925@math.ut.ee> <86vcqcf3da.fsf@sumi.keithp.com> <alpine.SOC.1.00.1111230911390.12655@math.ut.ee> <86obw3e133.fsf@sumi.keithp.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes, VT-x and VT-d are both enabled from BIOS setup.
> 
> Any reason for that? We've found all kinds of problems with DMAR enabled
> on these machines that is only resolved by completely turning it
> off. You might try with intel_iommu=off and make sure that's stable.

Well, there is reason for VT-x but actually none for VT-d because I am 
not giving out any PCI devices to virtual machines. Will also test 
witout it.

-- 
Meelis Roos (mroos@linux.ee)
