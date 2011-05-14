Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab1ENTlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 15:41:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41988 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab1ENTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 15:41:08 -0400
Date: Sat, 14 May 2011 20:40:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, johnpol@2ka.mipt.ru,
        a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com,
        dmitry.torokhov@gmail.com, Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        lrg@slimlogic.co.uk
Subject: Re: [PATCH 06/14] mfd: pxa-w1: MFD driver for PXA 1wire control +
	DS1WM chip
Message-ID: <20110514194017.GF30539@n2100.arm.linux.org.uk>
References: <1303135451-26362-7-git-send-email-haojian.zhuang@marvell.com> <20110426094836.GD2659@sortiz-mobl> <BANLkTinpFBfOEOR6Ox1ufEHZo3qwRq8zhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinpFBfOEOR6Ox1ufEHZo3qwRq8zhA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 10:21:25PM +0800, Haojian Zhuang wrote:
> But the key issue is that there's no common structure for clkdev. Now
> clkdev is only designed for deeply machine depend.
> 
> >From my view is that we need a common structure for clkdev.

You mean struct clk.

As I said on our call on Thursday, everyone knows this, and it's
something that has been worked on for the last year.  Concensus had
been reached and everyone had settled on a proposal, and just when
we were almost ready to merge it, the concensus fell apart again.

As a result of that, a common struct clk has been delayed - it's not
going to be in place for 2.6.40 (three months) but maybe we can reach
concensus again for the .41 merge window.

As I also said, this issue was talked about in a session at the Linaro
conference, and it will be interesting to hear what the result of that
session was.  At the moment, I'm entirely out of the loop on many things
that were discussed there (except for a message from tglx.)
