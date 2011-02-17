Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab1BQPSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:18:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61508 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab1BQPSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:18:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly macros
Date: Thu, 17 Feb 2011 16:18:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: John Linn <John.Linn@xilinx.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, glikely@secretlab.ca
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com> <201102171541.12261.arnd@arndb.de> <20110217151223.GJ24627@n2100.arm.linux.org.uk>
In-Reply-To: <20110217151223.GJ24627@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171618.44269.arnd@arndb.de>
X-Provags-ID: V02:K0:Q76U1xJO4jEnS1B5KtOGziZgz8p785TckLbtqlUrrfM
 BRvjshNiIyVU7WcxBuz8q06x2FNfJn6KYVvJMuhFrX8U+KBlgX
 F7BxaAYMNNnTG47kURAYrgG9xNV11ZWwloErZZZJ0EKtHskY0r
 1iVTWfxHmcLpyjdahJrLCpmZnCq6GHyVPWaoxgHLaLzpdr0dB9
 gdL6XF27qmaOu6l9usrrg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 February 2011, Russell King - ARM Linux wrote:
> > Actually, for correctness you should use the regular readl/writel, not
> > the __raw_ versions, which can result in reordered or partial accesses
> > on the bus.
> 
> Not in the decompressor.  readl/writel are unsupported there - the
> decompressor doesn't have the L2 cache support code and so the barriers
> necessary for readl/writel cause link errors.

Ah right, of course. Sorry for the confusion.

	Arnd
