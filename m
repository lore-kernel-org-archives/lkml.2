Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1LLLlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:41:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:52075 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab1LLLlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:41:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="46267456"
Date: Mon, 12 Dec 2011 12:46:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Afzal Mohammed <afzal@ti.com>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, nsekhar@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH RESEND v2 0/2] PMIC TPS65910 fixes
Message-ID: <20111212114618.GB13952@sortiz-mobl>
References: <1320758615-29085-1-git-send-email-afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320758615-29085-1-git-send-email-afzal@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mohamed,

On Tue, Nov 08, 2011 at 06:53:35PM +0530, Afzal Mohammed wrote:
> Hi,
> 
> This series applies over Kyle Manna's v3 patch series,
> https://lkml.org/lkml/2011/11/3/257,
> with changes as per comments on
> his/her 1/6 "mfd: TPS65910: Handle non-existent devices"
Kyle has not updated the patchset, afaik. So your patches don't apply on top
of my for-next branch. Please rebase them.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
