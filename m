Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab0JHS54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:57:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56328 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754532Ab0JHS5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:57:55 -0400
Date: Fri, 8 Oct 2010 11:58:08 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: Factor out WM831x I2C I/O from the core driver
Message-ID: <20101008185807.GB6098@opensource.wolfsonmicro.com>
References: <1286556780-5610-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20101008185708.GA4989@excalibur.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008185708.GA4989@excalibur.local>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 08:57:08PM +0200, Stefan Schmidt wrote:
> Hello.
> 
> On Fri, 2010-10-08 at 09:52, Mark Brown wrote:
> > In preparation for the addition of SPI support for the WM831x move the I2C
> > specific code into a separate file with a separate Kconfig option so the
> > I2C support can be excluded from the build.

> The factored out file is missing here. Makefile has a reference for wm831x-i2c,
> but you seemed to have forgotten to git add it.

Gah, will resend shortly.
