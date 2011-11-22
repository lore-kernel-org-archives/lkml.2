Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1KVE0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 23:26:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:20975 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab1KVE0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 23:26:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,551,1315206000"; 
   d="scan'208";a="39968764"
Subject: Re: [PATCH v2] dmaengine/ste_dma40: support pm in dma40
From: Vinod Koul <vinod.koul@intel.com>
To: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        rabin.vincent@stericsson.com
In-Reply-To: <1321531001-1090-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
References: <1321531001-1090-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 09:52:49 +0530
Message-ID: <1321935769.1516.218.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 17:26 +0530, Narayanan G wrote:
> This patch adds power management support to the dma40
> driver. The DMA registers are backed up and restored,
> during suspend/resume. Also flags to track the dma usage
> have been introduced to facilitate this. Patch also includes
> few other minor changes, related to formatting, comments.
> 
> Change-Id: I4da140e5aca462c22490146b5c03cff72a7bd803
> Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org> 

Applied after stripping the Change-ID

-- 
~Vinod

