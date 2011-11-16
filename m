Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab1KPFAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 00:00:50 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57735 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1KPFAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 00:00:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6531"; a="135701667"
Date: Tue, 15 Nov 2011 21:00:46 -0800
From: David Brown <davidb@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Nicolas Pitre <nico@fluxnic.net>, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Bruce Chang <brucechang@via.com.tw>,
        Harald Welte <HaraldWelte@viatech.com>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 4/4] mmc: Add mmc_host_<level> logging
Message-ID: <20111116050046.GA422@huya.qualcomm.com>
References: <cover.1321398814.git.joe@perches.com>
 <631c53d126feff0a99b61d9c9a00b308d2b638ee.1321398815.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <631c53d126feff0a99b61d9c9a00b308d2b638ee.1321398815.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 03:32:08PM -0800, Joe Perches wrote:

> Centralize the pr_<level> uses of mmc_hostname into specific
> mmc_host_<level> calls to allow a flexible presentation style
> and shorten the code a bit.

>  drivers/mmc/host/msm_sdcc.c     |  101 ++++++++++++++++++---------------------

The MSM ones at least are quite straightforward, so I'm fine with this
part of the change.

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
