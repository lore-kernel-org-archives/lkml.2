Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab2BTRHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:07:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:62986 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2BTRHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:07:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119403041"
Date: Mon, 20 Feb 2012 18:14:53 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@st.com>,
        Chris Blair <chris.blair@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2 v2] gpio/stmpe: support no-irq mode
Message-ID: <20120220171453.GH5387@sortiz-mobl>
References: <1327612635-9171-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327612635-9171-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Jan 26, 2012 at 10:17:15PM +0100, Linus Walleij wrote:
> From: Chris Blair <chris.blair@stericsson.com>
> 
> Adds support for boards which have an STMPE GPIO device without the
> interrupt pin connected. This means that no interrupt can be received
> but the GPIO pins can still be driven and read.
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: Viresh Kumar <viresh.kumar@st.com>
> Tested-by: Michel Jaouen <michel.jaouen@stericsson.com>
> Signed-off-by: Chris Blair <chris.blair@stericsson.com>
> ---
> ChangeLog v1->v2:
> - Removes the use of the new no_irq platform data member and
>   instead uses the value obtained for the cell irq to know if irqs
>   are supported or not. If irqs are not supported, the device
>   will not have been given an irq resource and the irq value
>   will be invalid.
> 
> This depends on the previous patch to the MFD
> code so should better be merged into the MFD tree with the
> previous patch.
Ok, I'm taking this one. It would be nice to get Grant's ACK as well.
Linus, you did not SOB this one. Did you simply forget ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
