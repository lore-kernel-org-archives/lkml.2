Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2FMVex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:34:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:56038 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab2FMVew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:34:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="152795173"
Date: Wed, 13 Jun 2012 14:34:51 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 3/4] perf, x86: check ucode before disabling PEBS on
 SandyBridge v3
Message-ID: <20120613213451.GC32604@tassilo.jf.intel.com>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
 <1339618842-26636-4-git-send-email-andi@firstfloor.org>
 <1339623054.8980.64.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339623054.8980.64.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Stephane actually wrote:
> 
> "Ok, so to close on this, I tried the 6/6/2012 ucode update on a few
> SNB-EP systems.
> 
> I got two answers depending on the stepping:
> C1 (stepping 6) -> 0x618
> C2 (stepping 7) -> 0x70c
> 
> So we need to check x86_mask for stepping and adjust the value of
> snb_ucode_rev accordingly for model 45."

not sure i understood your point? 
What do you want me to change?

I check different numbers on the different models.

FWIW it works on a Sandy Bridge E and I believe I didn't change
the logic for non E, which Stephane tested.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
