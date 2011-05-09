Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1EIMPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:15:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:19295 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1EIMPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:15:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,340,1301900400"; 
   d="scan'208";a="744417370"
Subject: Re: [PATCH V3 1/6] pch_dma: fix dma direction issue for ML7213 IOH
 video-in
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
In-Reply-To: <1304924980-3433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1304924980-3433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 17:12:38 +0530
Message-ID: <1304941358.28926.41.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 16:09 +0900, Tomoya MORINAGA wrote:
> Currently, even-channel number is set as tx direction and odd is set as rx.
> However, though video-in uses ch6, the direction is not tx but rx.
> This patch sets video-in's DMA direction correctly.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
> V2: Update Koul-Vinod's comments
If you're sending a patch series please ensure you send with the cover
letter - git send-email can do this for you.

Applied this time

-- 
~Vinod

