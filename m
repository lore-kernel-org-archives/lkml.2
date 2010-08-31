Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0HaSVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 14:21:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38282 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754073Ab0HaSVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:21:53 -0400
Date: Tue, 31 Aug 2010 19:21:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Brownell <david-b@pacbell.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] gpio: Add driver for basic memory-mapped GPIO
 controllers
Message-ID: <20100831182151.GD30599@rakim.wolfsonmicro.main>
References: <20100829212857.GA25592@oksana.dev.rtsoft.ru>
 <373151.77032.qm@web180311.mail.gq1.yahoo.com>
 <20100831175839.GA32468@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831175839.GA32468@oksana.dev.rtsoft.ru>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 09:58:39PM +0400, Anton Vorontsov wrote:
> The basic GPIO controllers may be found in various on-board FPGA
> and ASIC solutions that are used to control board's switches, LEDs,
> chip-selects, Ethernet/USB PHY power, etc.
> 
> Usually these controllers do not privide any means of pin setup
> (in/out/open drain).
> 
> The driver provides:
> - Support for 8/16/32/64 bits registers;
> - Support for GPIO controllers with clear/set registers;
> - Support for GPIO controllers with a single "data" register;
> - Support for big endian bits/GPIOs ordering (mostly used on PowerPC).
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
