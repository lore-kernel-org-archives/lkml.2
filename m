Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab1ACSGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 13:06:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:6604 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368Ab1ACSGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 13:06:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,267,1291622400"; 
   d="scan'208";a="874033591"
Message-ID: <4D22103C.2080705@linux.intel.com>
Date: Mon, 03 Jan 2011 10:06:52 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org
Subject: Re: [sodaville] [PATCH 02/11] x86: Add device tree support
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-3-git-send-email-bigeasy@linutronix.de> <1290807736.32570.143.camel@pasglop> <20101128134907.GA30784@www.tglx.de> <20101230082654.GB11721@angua.secretlab.ca> <AANLkTin2=T=v0ZNOpAGhwuM0i9Ts8Xr+kRtEJ95VGeOp@mail.gmail.com> <AANLkTinSr_KYkFNUmWbL2PUzS2Ose7cA5q8xUbLeUr=J@mail.gmail.com> <4D21F3DB.90504@linux.intel.com> <4D21F718.8010600@linux.intel.com> <20110103175254.GD2522@angua.secretlab.ca>
In-Reply-To: <20110103175254.GD2522@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 09:52 AM, Grant Likely wrote:
> 
> I think we've got an impedance mismatch.
> 
> The whole point of the ppc boot wrapper, and the kind of boot wrapper
> that I'm talking about here, is that it becomes part of the kernel
> image and is *not* part of firmware.  ie. an executable wrapper which
> carries the kernel as it's payload.  I'm wary too of depending of
> firmware to get things right because it can be so painful to change.
> 

The problem with that kind of boot wrapper is that they are
per-architecture, increasing the differences between architectures
needlessly, and they are often implemented very poorly.

As such, it's nice to have an ultimate fallback that doesn't depend on
anything outside ours -- the kernel community's -- control.

	-hpa
