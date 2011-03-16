Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1CPTnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:43:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:56038 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab1CPTns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:43:48 -0400
Message-Id: <b7da2f$qocenk@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,195,1299484800"; 
   d="scan'208";a="897989364"
Date: Wed, 16 Mar 2011 19:43:17 +0000
To: Melchior FRANZ <melchior.franz@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: i915/kms regression after 2.6.38-rc8 (was: Re: Linux 2.6.38)
References: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com> <201103161830.52231@rk-nord.at>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <201103161830.52231@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011 18:30:51 +0100, Melchior FRANZ <melchior.franz@gmail.com> wrote:
> On my i915 using Acer TravelMate 5735z I could run kernel 2.6.38-rc8
> with KMS. On 2.6.38 I get a black screen instead. In case anyone
> cares, just tell me what information you need. (bisect result on
> request, but I assume the experts know which patch caused it.)

There's only one patch directly related to i915, so you could begin there.
Useful information to include is a dmesg (particularly one with
drm.debug=0xe kernel parameters) and lspci (though google says you have a
gm45).
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
