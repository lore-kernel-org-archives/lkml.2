Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab2EaEWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 00:22:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:28364 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab2EaEWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 00:22:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="150634119"
Date: Wed, 30 May 2012 21:22:49 -0700
From: Andi Kleen <ak@linux.intel.com>
To: David Mackey <tdmackey@twitter.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, penberg@kernel.org,
        cl@linux.com
Subject: Re: [PATCH v4] slab/mempolicy: always use local policy from
 interrupt context
Message-ID: <20120531042249.GG9850@tassilo.jf.intel.com>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org>
 <1338429749-5780-1-git-send-email-tdmackey@twitter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338429749-5780-1-git-send-email-tdmackey@twitter.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [tdmackey@twitter.com: Rework patch logic and avoid dereference of current 
> task if in interrupt context.]

avoiding this reference doesn't make sense, it's totally valid.
This is based on a older version. I sent the fixed one some time ago.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
