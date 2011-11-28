Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1K1Dmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 22:42:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:60441 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab1K1Dmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 22:42:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,581,1315206000"; 
   d="scan'208";a="41575235"
Subject: Re: [PATCH] dmaengine/ste_dma40: Add support to use lcla area from
 esram
From: Vinod Koul <vinod.koul@intel.com>
To: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Cc: linux-kernel@vger.kernel.org, rabin.vincent@stericsson.com,
        linus.walleij@stericsson.com
In-Reply-To: <1321950415-31864-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
References: <1321950415-31864-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 09:09:45 +0530
Message-ID: <1322451585.1516.978.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 13:56 +0530, Narayanan G wrote:
> This patch provides an option of having the lcla (link address)
> in ESRAM instead of allocating it. The bool value (use_esram_lcla)
> in the stedma40_platform_data if set to true, then the lcla
> address would be taken from platform resources. Also, the
> corresponding esram regulator is managed in the
> suspend/resume functions.
> 
> Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com> 

Applied, Thanks


-- 
~Vinod

