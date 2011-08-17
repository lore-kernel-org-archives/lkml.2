Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1HQBAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 21:00:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35156 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751661Ab1HQBAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 21:00:08 -0400
Date: Wed, 17 Aug 2011 09:59:55 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, sdharia@codeaurora.org,
        David Brown <davidb@codeaurora.org>, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20110817005954.GB27099@opensource.wolfsonmicro.com>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
 <4E4AA52E.1070706@codeaurora.org>
 <0446c62c2d4a2c60442c582b4f61f5d3.squirrel@www.codeaurora.org>
 <4380004.YTvKt3Mlxd@wuerfel>
 <4E4AFCC9.7020109@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4AFCC9.7020109@codeaurora.org>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 05:27:05PM -0600, Kenneth Heitke wrote:

> For the proposed implementation, the client drivers are probed
> before their devices are discovered because the client driver may
> need to power-up the device or pull it out of reset.  Once the
> device is powered up, the call to get_logical_address() will let the
> client know whether or not their device has enumerated.

There's a callback generated to left the client know when this has
happened I'd expect?
