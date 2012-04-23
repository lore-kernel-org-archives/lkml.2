Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2DWKty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:49:54 -0400
Received: from plane.gmane.org ([80.91.229.3]:34303 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab2DWKtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:49:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="135609136"
From: Andi Kleen <andi@firstfloor.org>
To: HATAYAMA Daisuke 
	<public-d.hatayama-+CUm20s59erQFUHtdCDX3A@plane.gmane.org>
Cc: public-kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@plane.gmane.org,
        public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        public-ebiederm-aS9lmoZGLiVWk0Htik3J/w@plane.gmane.org,
        public-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@plane.gmane.org,
        public-kumagai-atsushi-biTfD1RFvDe45+QrQBaojngSJqDPrsil@plane.gmane.org,
        fenghua.yu@intel.com
Subject: Re: [PATCH 2/2] Enter 2nd kernel with BSP
References: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
	<20120416022139.9303.56284.stgit@localhost6.localdomain6>
Date: Mon, 23 Apr 2012 03:46:15 -0700
In-Reply-To: <20120416022139.9303.56284.stgit@localhost6.localdomain6>
	(HATAYAMA Daisuke's message of "Mon, 16 Apr 2012 11:21:39 +0900")
Message-ID: <m2mx62ohe0.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



HATAYAMA Daisuke <d.hatayama-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
writes:

> Split logic into BSP's and AP's: BSP waits for AP halting.
>
> Don't remove variable crashing_cpu for debugging use; useful for
> determining one what CPU crash happens.

Fenghua has this patchkit to allow offlining the BSP. What happens then?

It would be good to understand why initializing APs from other APs
should not work.  Not aware of such a limitation in x86.

AFAIK when we online a random cpu after boot there is no effort to do it
from BSP. Why does that work and not from the kexec boot?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

