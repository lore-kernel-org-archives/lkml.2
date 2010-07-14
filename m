Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0GNJTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:19:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:61588 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab0GNJTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:19:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,201,1278313200"; 
   d="scan'208";a="535382465"
Date: Wed, 14 Jul 2010 11:19:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] MFD: Add JZ4740 ADC driver
Message-ID: <20100714091934.GA2771@sortiz-mobl>
References: <1276924111-11158-23-git-send-email-lars@metafoo.de>
 <1278899288-14921-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278899288-14921-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Mon, Jul 12, 2010 at 03:48:08AM +0200, Lars-Peter Clausen wrote:
> This patch adds a MFD driver for the JZ4740 ADC unit. The driver is used to
> demultiplex IRQs and synchronize access to shared registers between the battery,
> hwmon and (future) touchscreen driver.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
Patch applied, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
