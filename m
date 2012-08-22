Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2HVEO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:14:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:17444 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab2HVEOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:14:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,807,1336374000"; 
   d="scan'208";a="136698916"
Subject: Re: [PATCH] drivers/dma/sirf-dma.c: fix usage of devm functions
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Barry Song <baohua.song@csr.com>, Dan Williams <dan.j.williams@intel.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1344069330-29569-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1344069330-29569-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Aug 2012 09:46:34 +0530
Message-ID: <1345608994.1895.73.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-04 at 10:35 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Fix some problems with the use of devm_ functions.
Applied, thanks


-- 
~Vinod

