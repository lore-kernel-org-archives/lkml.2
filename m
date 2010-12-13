Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab0LMMjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:39:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33063 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756768Ab0LMMji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:39:38 -0500
Date: Mon, 13 Dec 2010 12:39:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] mfd: wm831x: irq_data conversion.
Message-ID: <20101213123935.GB21535@rakim.wolfsonmicro.main>
References: <cover.1292241952.git.buytenh@wantstofly.org>
 <20101213123121.GB15575@mail.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213123121.GB15575@mail.wantstofly.org>
X-Cookie: Leave no stone unturned.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 01:31:21PM +0100, Lennert Buytenhek wrote:
> Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>

If you're doing this sort of work you really need to work against -next
or the individual development tree rather than Linus' tree.  The Wolfson
drivers have been converted in -next for a while now.

I also posted patches for everything in MFD except ezx-pcap over the
weekend - I pushed a branch up to a git tree earlier today with these
changes in, I'll try to keep it up to date with the acks I'm getting.
I'll add Lennart's ezx-pcap patch to that.

The following changes since commit 3ec93fcb34a97a9806a7280b136a7af20edf61f1:

  mfd: Fix twl_probe section mismatch warning in mfd/twl-core.c (2010-12-10 20:59:59 +0100)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc-2.6.git mfd-irq

Mark Brown (20):
      mfd: Staticise unexported symbols in ASIC3
      mfd: Correct ASIC3 IRQ_OWM resource setup
      mfd: Remove ARCH_U8500 dependency from AB8500
      mfd: Staticise internal functions in HTC I2CCPLD driver
      mfd: Convert 88PM860x driver to new irq_ APIs
      mfd: Convert ASIC3 to new irq_ APIs
      mfd: Convert AB3500 to new irq_ APIs
      mfd: Convert AB8500 to new irq_ methods
      mfd: Convert HTC EGPIO driver to irq_ API
      mfd: Convert HTC I2C CPLD driver to irq_ API
      mfd: Convert jz4740-adc to new irq_ methods
      mfd: Convert max8925 to new irq_ API
      mfd: Convert MAX8998 driver to irq_ API
      mfd: Convert SMTPE driver to new irq_ APIs
      mfd: Convert t7166xb driver to new irq_ API
      mfd: Convert tc35892 to new irq_ APIs
      mfd: Convert tc6393xb driver to new irq_ APIs
      mfd: Convert tps6586x driver to new irq_ API
      mfd: Convert TWL4030 to new irq_ APIs
      mfd: Convert Wolfson MFD drivers to use irq_data accessor function

 drivers/mfd/88pm860x-core.c |   36 ++++++++++--------------
 drivers/mfd/Kconfig         |    2 +-
 drivers/mfd/ab3550-core.c   |   28 +++++++++----------
 drivers/mfd/ab8500-core.c   |   28 +++++++++---------
 drivers/mfd/asic3.c         |   62 +++++++++++++++++++++---------------------
 drivers/mfd/htc-egpio.c     |   27 +++++++++---------
 drivers/mfd/htc-i2cpld.c    |   40 ++++++++++++++--------------
 drivers/mfd/jz4740-adc.c    |   25 ++++++++---------
 drivers/mfd/max8925-core.c  |   30 ++++++++++----------
 drivers/mfd/max8998-irq.c   |   30 +++++++++++---------
 drivers/mfd/stmpe.c         |   28 +++++++++---------
 drivers/mfd/t7l66xb.c       |   20 +++++++-------
 drivers/mfd/tc35892.c       |    8 +++---
 drivers/mfd/tc6393xb.c      |   22 +++++++-------
 drivers/mfd/tps6586x.c      |   28 +++++++++---------
 drivers/mfd/twl4030-irq.c   |   28 +++++++++---------
 drivers/mfd/wm831x-irq.c    |   10 +++---
 drivers/mfd/wm8350-irq.c    |    8 +++---
 drivers/mfd/wm8994-irq.c    |    8 +++---
 19 files changed, 231 insertions(+), 237 deletions(-)
