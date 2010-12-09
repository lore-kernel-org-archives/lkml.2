Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab0LIMNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:13:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:21087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab0LIMNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:13:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,319,1288594800"; 
   d="scan'208";a="582088172"
Date: Thu, 9 Dec 2010 13:13:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] MFD: ab8500-core interrupt ffs bit bug
Message-ID: <20101209121317.GE8884@sortiz-mobl>
References: <1291298809-3275-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291298809-3275-1-git-send-email-mattias.wallin@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattias,

On Thu, Dec 02, 2010 at 03:06:49PM +0100, Mattias Wallin wrote:
> This patch fixes a bug in ab8500 interrupt handling
Patch applied. This also looks like a good candidate for 2.6.37.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
