Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2DWKtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:49:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:23937 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab2DWKtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:49:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144801114"
From: Andi Kleen <andi@firstfloor.org>
To: HATAYAMA Daisuke 
	<d.hatayama-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 2/2] Enter 2nd kernel with BSP
References: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
	<20120416022139.9303.56284.stgit@localhost6.localdomain6>
cc: linux-kernel@vger.kernel.org, fenghua.yu@intel.com
Date: Mon, 23 Apr 2012 03:49:15 -0700
In-Reply-To: <20120416022139.9303.56284.stgit@localhost6.localdomain6>
	(HATAYAMA Daisuke's message of "Mon, 16 Apr 2012 11:21:39 +0900")
Message-ID: <m2ipgqoh90.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
