Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab1A3XUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 18:20:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:12764 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048Ab1A3XUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 18:20:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,402,1291622400"; 
   d="scan'208";a="882544000"
Date: Mon, 31 Jan 2011 00:20:42 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Leave acknowledgement of WM831x touchscreen IRQs
 to the driver
Message-ID: <20110130232040.GC2565@sortiz-mobl>
References: <1295012296-21716-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295012296-21716-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jan 14, 2011 at 01:38:16PM +0000, Mark Brown wrote:
> The WM831x touchscreen interrupts need acknowledgement even when using
> direct signals to the CPU (which don't go through the core) so leave
> the acknowledgement up to the touchscreen driver for simplicity.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
