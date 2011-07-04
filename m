Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab1GDOUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:20:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:15927 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab1GDOUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:20:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,472,1304319600"; 
   d="scan'208";a="23614684"
Date: Mon, 4 Jul 2011 16:21:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Don't ask about the TPS65912 core driver in Kconfig
Message-ID: <20110704142101.GF3021@sortiz-mobl>
References: <1308750838-26534-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308750838-26534-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jun 22, 2011 at 02:53:58PM +0100, Mark Brown wrote:
> The user has to select the I2C and SPI drivers individually and they select
> the core driver for the device so there's no point in presenting the user
> with an option for the core driver.
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
