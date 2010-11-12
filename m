Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab0KLKHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:07:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:16882 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab0KLKHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:07:13 -0500
Message-Id: <5b55a1$il2924@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,186,1288594800"; 
   d="scan'208";a="626074692"
Date: Fri, 12 Nov 2010 10:07:09 +0000
To: Ike Panhc <ike.pan@canonical.com>, stable@kernel.org
Subject: Re: [PATCH] [Stable] agp/intel: complete the enablement for B43.1
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>
In-Reply-To: <1289555843-6425-1-git-send-email-ike.pan@canonical.com>
References: <1289555843-6425-1-git-send-email-ike.pan@canonical.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010 17:57:23 +0800, Ike Panhc <ike.pan@canonical.com> wrote:
> Without this patch, X fails to start on 2.6.35.y kernel. After patched, X
> starts.
> 
> This patch is made for 2.6.35.y and I believe it suits for 2.6.36.y.
> 
> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>

-- 
Chris Wilson, Intel Open Source Technology Centre
