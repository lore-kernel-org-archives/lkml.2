Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1GMXN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:13:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:63133 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab1GMXN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:13:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,527,1304319600"; 
   d="scan'208";a="26957412"
Subject: Re: [PATCH 0/2] dmaengine/ste_dma40: Fix implementation of
 issue_pending
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin.vincent@stericsson.com>
In-Reply-To: <1309123793-7806-1-git-send-email-per.forlin@linaro.org>
References: <1309123793-7806-1-git-send-email-per.forlin@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 04:02:56 +0530
Message-ID: <1310596376.1536.23.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-26 at 23:29 +0200, Per Forlin wrote:
> Resolve issue pending TOOD for ste_dma40
> 
> Per Forlin (2):
>   dmaengine/ste_dma40: add a separate queue for pending requests
>   dmaengine: remove ste_dma40 from issue_pending TODO
> 
>  drivers/dma/TODO        |    1 -
>  drivers/dma/ste_dma40.c |   26 ++++++++++++++++++++++++--
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 

Applied, Thanks
-- 
~Vinod

