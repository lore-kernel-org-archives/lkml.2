Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab0HQF1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:27:13 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:48518 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0HQF1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:27:12 -0400
Date: Tue, 17 Aug 2010 08:27:06 +0300 (EEST)
Message-Id: <20100817.082706.39158708.Hiroshi.DOYU@nokia.com>
To: fernando.lugo@ti.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        h-kanigeri2@ti.com
Subject: Re: [PATCH] iommu: fix end address of vm area comparation in
 alloc_iovm_area
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <496565EC904933469F292DDA3F1663E602CA4D894C@dlee06.ent.ti.com>
References: <496565EC904933469F292DDA3F1663E602CA4D8949@dlee06.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CA4D894C@dlee06.ent.ti.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "ext Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Subject: RE: [PATCH] iommu: fix end address of vm area comparation in alloc_iovm_area
Date: Tue, 17 Aug 2010 06:48:14 +0200

> From: linux-omap-owner@vger.kernel.org [linux-omap-owner@vger.kernel.org] On Behalf Of Guzman Lugo, Fernando [fernando.lugo@ti.com]
> Sent: Monday, August 16, 2010 10:51 PM
> To: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Hiroshi.DOYO@nokia.com; Kanigeri, Hari
> Subject: [PATCH] iommu: fix end address of vm area comparation in alloc_iovm_area
> 
> From cc48c0adaee97c8385a356aefa5b64a51818b4fd Mon Sep 17 00:00:00 2001
> From: Fernando Guzman Lugo <x0095840@ti.com>
> Date: Mon, 16 Aug 2010 22:28:24 -0500
> Subject: [PATCH] iommu: fix end address of vm area comparation in alloc_iovm_area
> 
> End address of the vm area is “start + bytes -1”,
> not “start + byte”. This patch fixes that issue by doing
> an inclusive comparison with tmp->da_start. This issue
> was preventing allocate an area of size exactly the same
> than the free area. I did no change the value of da_end
> of each vm area because it is used to get area size in
> several places.

Ok for me. Is this patch against the latest?
