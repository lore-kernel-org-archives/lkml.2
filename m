Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0KZK5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:57:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:42195 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab0KZK5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:57:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,260,1288594800"; 
   d="scan'208";a="353499902"
Date: Fri, 26 Nov 2010 11:57:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, cjb@laptop.org, dsd@laptop.org
Subject: Re: [PATCH 1/4] MFD: add cs5535-mfd driver for CS5535/CS5536
 support
Message-ID: <20101126105717.GF5520@sortiz-mobl>
References: <20101023004102.674cdc45@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101023004102.674cdc45@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Sat, Oct 23, 2010 at 12:41:02AM -0700, Andres Salomon wrote:
> 
> Add an MFD driver to handle the ISA device on CS5535 and CS5536 southbridges.
> This ISA bridge is actually multiple devices; GPIOs, MFGPTs, etc.
The patch looks good, and I applied it.
I just have one minor nitpick though, that you may want to address with a
further patch:

> +config MFD_CS5535
> +	tristate "Support for CS5535 and CS5536 southbridge core functions"
An AMD Geode mention should appear here. It might not be obvious to everyone
where those devices can be found.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
