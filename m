Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0JSPOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:14:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57084 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751845Ab0JSPOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:14:35 -0400
Date: Tue, 19 Oct 2010 08:14:16 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: Factor out WM831x I2C I/O from the core driver
Message-ID: <20101019151415.GA2677@opensource.wolfsonmicro.com>
References: <1286573003-13889-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20101019111553.GO2736@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019111553.GO2736@sortiz-mobl>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 01:15:54PM +0200, Samuel Ortiz wrote:

> I think we should select MFD_WM831X here as well otherwise there's nothing
> preventing us from building the I2C or the SPI part without the core one. And
> that leads to a build breakage.

I agree, I'll try to send a followup out unless you update the patch
before I get to it.
