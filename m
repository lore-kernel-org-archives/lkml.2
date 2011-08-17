Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1HQGcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 02:32:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60096 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751893Ab1HQGcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 02:32:52 -0400
Date: Wed, 17 Aug 2011 15:32:42 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sagar Dharia <sdharia@codeaurora.org>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20110817063237.GA12344@opensource.wolfsonmicro.com>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
 <4E4AA52E.1070706@codeaurora.org>
 <0446c62c2d4a2c60442c582b4f61f5d3.squirrel@www.codeaurora.org>
 <4380004.YTvKt3Mlxd@wuerfel>
 <4E4AFCC9.7020109@codeaurora.org>
 <20110817005954.GB27099@opensource.wolfsonmicro.com>
 <cf66eafcc04bf565edcb330f66a3e12a.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf66eafcc04bf565edcb330f66a3e12a.squirrel@www.codeaurora.org>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 06:54:45PM -0700, Sagar Dharia wrote:
> > On Tue, Aug 16, 2011 at 05:27:05PM -0600, Kenneth Heitke wrote:

> > There's a callback generated to left the client know when this has
> > happened I'd expect?

> As of now, there is no callback to notify them. They can either query it
> during 1st transaction, or retry with some delay in the probe itself.
> Callback is a good idea and we can definitely use it to inform clients
> that their device has come up.

It's pretty much essential, I'd expect slimbus devices will want to
provide always on functionality like accessory detection which there's
no reason to delay.
