Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1AaKpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:45:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:38632 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab1AaKpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:45:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,403,1291622400"; 
   d="scan'208";a="598011957"
Date: Mon, 31 Jan 2011 11:45:45 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: Remove obsolete cleanup for clientdata
Message-ID: <20110131104544.GB5954@sortiz-mobl>
References: <1295865880-27672-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295865880-27672-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi _Wolfram_,

On Mon, Jan 24, 2011 at 11:44:27AM +0100, Wolfram Sang wrote:
> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit or error. This is obsolete meanwhile, the core will do it.
Thanks a lot, patch applied now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
