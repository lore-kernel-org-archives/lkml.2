Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab1ACSK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 13:10:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:22818 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab1ACSK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 13:10:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,267,1291622400"; 
   d="scan'208";a="589460682"
Message-ID: <4D221130.1020405@linux.intel.com>
Date: Mon, 03 Jan 2011 10:10:56 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Rob Landley <rob@landley.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [sodaville] [PATCH 02/11] x86: Add device tree support
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>	<1290706801-7323-3-git-send-email-bigeasy@linutronix.de>	<1290807736.32570.143.camel@pasglop>	<20101128134907.GA30784@www.tglx.de>	<20101230082654.GB11721@angua.secretlab.ca>	<AANLkTin2=T=v0ZNOpAGhwuM0i9Ts8Xr+kRtEJ95VGeOp@mail.gmail.com>	<AANLkTinSr_KYkFNUmWbL2PUzS2Ose7cA5q8xUbLeUr=J@mail.gmail.com>	<4D21F3DB.90504@linux.intel.com> <4D21F718.8010600@linux.intel.com>	<20110103175254.GD2522@angua.secretlab.ca> <4D22103C.2080705@linux.intel.com>
In-Reply-To: <4D22103C.2080705@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 10:06 AM, H. Peter Anvin wrote:
> 
> The problem with that kind of boot wrapper is that they are
> per-architecture, increasing the differences between architectures
> needlessly, and they are often implemented very poorly.
> 
> As such, it's nice to have an ultimate fallback that doesn't depend on
> anything outside ours -- the kernel community's -- control.
> 

In the case of x86, it's not just per architecture but actually per
platform interface, which is what aggravates the situation additionally.
 Unfortunately a lot of embedded x86 vendors seem extremely busy
recreating all the mistakes embedded developers on other platforms have
ever made, because "it's what they know"...

	-hpa
