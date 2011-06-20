Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1FTN0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:26:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:60635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab1FTN0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:26:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,394,1304319600"; 
   d="scan'208";a="18392205"
Date: Mon, 20 Jun 2011 15:26:26 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        parthab@india.ti.com
Subject: Re: [PATCH] mfd: omap: fix the crash during omap ehci or ohci driver
 initialization
Message-ID: <20110620132626.GJ22420@sortiz-mobl>
References: <1307367739-20110-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307367739-20110-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keshava,

On Mon, Jun 06, 2011 at 07:12:19PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
> 
> Oops are produced during initialization of ehci and ohci
> drivers. This is because the run time pm apis are used by
> the driver but the corresponding hwmod structures and
> initialization is not merged. 
You mean they're currently checked in a different tree ? Is that a public one?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
