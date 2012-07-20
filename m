Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab2GTGlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 02:41:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:49413 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab2GTGlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 02:41:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181113191"
Subject: Re: [PATCH] dmaengine: Cleanup logging messages
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1342630288.9551.19.camel@joe2Laptop>
References: <1342611251-16935-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1342630288.9551.19.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jul 2012 12:11:46 +0530
Message-ID: <1342766506.1726.248.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 09:51 -0700, Joe Perches wrote:
> Use a more current logging style.
> 
> Add pr_fmt to prefix dmaengine: to messages.
> Convert printk(KERN_ERR to pr_err(.
> Convert embedded function name use to "%s: ", __func__
> Align arguments.
> 
Applied thanks

-- 
~Vinod

