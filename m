Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1K2IIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 03:08:37 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:44512 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab1K2IIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 03:08:36 -0500
Date: Tue, 29 Nov 2011 10:08:33 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Keith Packard <keithp@keithp.com>
cc: David Woodhouse <dwmw2@infradead.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Bisected regression: hang on i915 between 3.1.0-rc9 and 3.1.0
In-Reply-To: <86vcqcf3da.fsf@sumi.keithp.com>
Message-ID: <alpine.SOC.1.00.1111291008040.13271@math.ut.ee>
References: <alpine.SOC.1.00.1111221207090.6490@math.ut.ee> <alpine.SOC.1.00.1111221306410.8925@math.ut.ee> <86vcqcf3da.fsf@sumi.keithp.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 3.0 worked fine, 3.1-rc9 worked fine, I think -rc10 too. 3.1 release 
> > > hangs in random places while using X.
> 
> Do you have VT-d enabled in the BIOS?

Disabled VT-d in BIOS and 3.2-rc3 has been running stable since then. SO 
it seems to be the same problem.

-- 
Meelis Roos (mroos@linux.ee)
