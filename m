Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1ACQTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:19:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:62276 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab1ACQTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:19:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,267,1291622400"; 
   d="scan'208";a="369415264"
Message-ID: <4D21F718.8010600@linux.intel.com>
Date: Mon, 03 Jan 2011 08:19:36 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org
Subject: Re: [sodaville] [PATCH 02/11] x86: Add device tree support
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>	<1290706801-7323-3-git-send-email-bigeasy@linutronix.de>	<1290807736.32570.143.camel@pasglop>	<20101128134907.GA30784@www.tglx.de>	<20101230082654.GB11721@angua.secretlab.ca>	<AANLkTin2=T=v0ZNOpAGhwuM0i9Ts8Xr+kRtEJ95VGeOp@mail.gmail.com>	<AANLkTinSr_KYkFNUmWbL2PUzS2Ose7cA5q8xUbLeUr=J@mail.gmail.com> <4D21F3DB.90504@linux.intel.com>
In-Reply-To: <4D21F3DB.90504@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 08:05 AM, H. Peter Anvin wrote:
> On 12/30/2010 12:58 PM, Grant Likely wrote:
>>
>> Right, but in all of those cases a boot wrapper provides the same
>> functionality with better flexability, such as being able to provided
>> the dtb image(s) at install time instead of compile time.
>>
> 
> Assuming the boot wrapper is written correctly.  I have seen a number of
> cases in which it was not, and it being "already locked into firmware"
> and not changeable.
> 
> It's a nice theory.  And in theory, theory and practice agree.
> 

By the way, this is the same reason we also allow the initramfs and even
the command line to be compiled in.

	-hpa
