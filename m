Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2ENUHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:07:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:2154 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab2ENUHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:07:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99992322"
Date: Mon, 14 May 2012 22:16:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] mfd: lm3533: silence a gcc warning
Message-ID: <20120514201653.GA12740@sortiz-mobl>
References: <20120512110104.GC19472@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120512110104.GC19472@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Sat, May 12, 2012 at 02:01:04PM +0300, Dan Carpenter wrote:
> This is supposed to be umode_t.  It causes a GCC warning:
> drivers/mfd/lm3533-core.c:440:2: warning: initialization from incompatible pointer type [enabled by default]
> drivers/mfd/lm3533-core.c:440:2: warning: (near initialization for ‘lm3533_attribute_group.is_visible’) [enabled by default]
> 
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
