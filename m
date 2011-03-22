Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1CVOmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:42:40 -0400
Received: from linux-sh.org ([111.68.239.195]:51974 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab1CVOmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:42:36 -0400
Date: Tue, 22 Mar 2011 23:42:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Prasad Joshi <prasadjoshi124@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 07/22] mm, sh: add gfp flags variant of pmd and pte allocations
Message-ID: <20110322144227.GA30303@linux-sh.org>
References: <20110318194135.GA4746@prasad-kvm> <20110318194341.GB4746@prasad-kvm> <20110318194600.GC4746@prasad-kvm> <20110318194740.GD4746@prasad-kvm> <20110318194929.GE4746@prasad-kvm> <20110318195035.GF4746@prasad-kvm> <20110318195141.GG4746@prasad-kvm> <20110318195307.GH4746@prasad-kvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318195307.GH4746@prasad-kvm>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 07:53:07PM +0000, Prasad Joshi wrote:
> 
> - Added __pte_alloc_one_kernel() function to allow caller to allocation flag.
>    Like pte_alloc_one_kernel() this newly added function calls
>    quicklist_alloc() and passes the allocation flag down the call hierarchy.
> 
> - The function pte_alloc_one_kernel() is modified to call
>   __pte_alloc_one_kernel() using the correct allocation flag.
> 
> - Similar changes for pmd allocations. Added function __pmd_alloc_one().
> 
> - The changes help in fixing the Bug 30702.
> 
> Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
> Signed-off-by: Anand Mitra <mitra@kqinfotech.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
