Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2AWM41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 07:56:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59273 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2AWM4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 07:56:25 -0500
Date: Mon, 23 Jan 2012 05:56:26 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Harini Jayaraman <harinij@codeaurora.org>, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kheitke@codeaurora.org, spi-devel-general@lists.sourceforge.net,
        davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] spi: QUP based bus driver for Qualcomm MSM chipsets
Message-ID: <20120123125626.GA23571@ponder.secretlab.ca>
References: <y>
 <1321307907-31508-1-git-send-email-harinij@codeaurora.org>
 <20111207223757.GE3744@pengutronix.de>
MIME-Version: 1.0
In-Reply-To: <20111207223757.GE3744@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 11:37:58PM +0100, Wolfram Sang wrote:
> On Mon, Nov 14, 2011 at 02:58:27PM -0700, Harini Jayaraman wrote:
> > This bus driver supports the QUP SPI hardware controller in the Qualcomm
> > MSM SOCs. The Qualcomm Universal Peripheral Engine (QUP) is a general
> > purpose data path engine with input/output FIFOs and an embedded SPI
> > mini-core. The driver currently supports only FIFO mode.
> > 
> > Signed-off-by: Harini Jayaraman <harinij@codeaurora.org>
> 
> Wow, this driver is huge. This is a rough review only, mainly to see
> what can go away. This will make further reviews easier.
> 
> > ---
> > v2: Updated copyright information (addresses comments from Bryan Huntsman).
> >     Files renamed.
> > ---
> >  drivers/spi/Kconfig                   |   10 +
> >  drivers/spi/Makefile                  |    1 +
> >  drivers/spi/spi-qup.c                 | 1144 +++++++++++++++++++++++++++++++++
> >  drivers/spi/spi-qup.h                 |  436 +++++++++++++
> >  include/linux/platform_data/msm_spi.h |   19 +
> >  5 files changed, 1610 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/spi/spi-qup.c
> >  create mode 100644 drivers/spi/spi-qup.h

Why the separate header file?  From what I can tell, only spi-qup.c
uses it, so the definitions should be directly in spi-qup.c.

g.
