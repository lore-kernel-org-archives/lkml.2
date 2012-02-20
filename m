Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab2BTQcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:32:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:8939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab2BTQcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:32:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119392446"
Date: Mon, 20 Feb 2012 17:39:27 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, kernel@pengutronix.de
Subject: Re: [PATCH 1/3] mfd: Add basic support for the Congatec CGEB BIOS
 interface
Message-ID: <20120220163927.GY5387@sortiz-mobl>
References: <1328102793-4313-1-git-send-email-s.hauer@pengutronix.de>
 <1328102793-4313-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328102793-4313-2-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Wed, Feb 01, 2012 at 02:26:31PM +0100, Sascha Hauer wrote:
> The Congatec CGEB is a BIOS interface found on some Congatec x86
> modules. It provides access to on board peripherals like I2C busses
> and watchdogs. This driver contains the basic support for accessing
> the CGEB interface and registers the child devices.
After looking at the code, I'm not entirely sure this one belongs to
drivers/mfd/. Have you thought about putting it under arch/x86/platform/ ?
There are similar examples there, like uv or olpc.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
