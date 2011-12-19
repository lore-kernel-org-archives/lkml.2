Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1LSLhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:37:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:22978 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab1LSLhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:37:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="89017695"
Date: Mon, 19 Dec 2011 12:42:10 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: Fix cs5535-mfd driver name
Message-ID: <20111219114210.GK11800@sortiz-mobl>
References: <20111205224639.13f1e95d@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205224639.13f1e95d@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Mon, Dec 05, 2011 at 10:46:39PM +0100, Jean Delvare wrote:
> Fix cs5535-mfd driver name to make CONFIG_DEBUG_SECTION_MISMATCH=y
> happy:
> 
> WARNING: drivers/mfd/cs5535-mfd.o(.data+0x20): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devinit.text:cs5535_mfd_probe()
> The variable cs5535_mfd_drv references
> the function __devinit cs5535_mfd_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
A similar patch is already queued in my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
