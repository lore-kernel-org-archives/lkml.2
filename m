Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab0LOKUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:20:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:20500 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab0LOKUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:20:42 -0500
Message-Id: <5b55a1$iv0t6h@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,347,1288594800"; 
   d="scan'208";a="636515537"
Date: Wed, 15 Dec 2010 10:20:23 +0000
To: Hui Zhu <teawater@gmail.com>
Subject: Re: [BUG] i915 boot got black screen with 2.6.37-rc5+
Cc: linux-kernel@vger.kernel.org, keithp@keithp.com, ak@linux.intel.com,
        gregkh@suse.de, stable@kernel.org, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <AANLkTim=k601vg+sJJH3bvdfAmrCbCEouL78XoVxuDwy@mail.gmail.com>
References: <AANLkTimOOmFqxU=r+-RphdfPJ54Qr+6LHU60Grzpnerr@mail.gmail.com> <b9dded$hcr3k7@orsmga002.jf.intel.com> <AANLkTim=k601vg+sJJH3bvdfAmrCbCEouL78XoVxuDwy@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 17:28:45 +0800, Hui Zhu <teawater@gmail.com> wrote:
> lspci | grep Display
> 00:02.1 Display controller: Intel Corporation 82Q35 Express Integrated
> Graphics Controller (rev 02)

Q35. I wasn't expecting that. Can you please add drm.debug=0xe to your
boot line and attach the dmesg from rc3 and rc5? Thanks.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
