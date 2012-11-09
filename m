Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab2KIJ3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:29:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:46631 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab2KIJ3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:29:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,744,1344236400"; 
   d="scan'208";a="217200713"
Date: Fri, 9 Nov 2012 10:28:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Wei WANG <wei_wang@realsil.com.cn>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: rtsx_pcr: Include linux/slab.h to fix build error
Message-ID: <20121109092858.GC27828@sortiz-mobl>
References: <1352438201.23783.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352438201.23783.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Fri, Nov 09, 2012 at 01:16:41PM +0800, Axel Lin wrote:
> Fix below build error:
I already pushed a similar patch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
