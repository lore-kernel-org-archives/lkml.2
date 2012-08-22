Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2HVE1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:27:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:28069 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab2HVE1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:27:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,807,1336374000"; 
   d="scan'208";a="136701447"
Subject: Re: [PATCH 2/5] drivers/dma/amba-pl08x.c: fix error return code
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1344949115-13266-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1344949115-13266-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1344949115-13266-3-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Aug 2012 09:59:30 +0530
Message-ID: <1345609770.1895.81.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 14:58 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert a 0 error return code to a negative one, as returned elsewhere in the
> function.
Applied, thanks

-- 
~Vinod

