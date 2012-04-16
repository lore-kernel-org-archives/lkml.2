Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab2DPXW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:22:56 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:38366 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab2DPXWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:22:54 -0400
From: Marc Reilly <marc@cpdesign.com.au>
Reply-To: marc@cpdesign.com.au
Organization: Creative Product Design
To: sameo@linux.intel.com, spi-devel-general@lists.sourceforge.net
Subject: Re: mc13xxx: add I2C support, V5
Date: Tue, 17 Apr 2012 09:21:41 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
References: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
In-Reply-To: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204170921.42027.marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,


On Sunday, April 01, 2012 04:41:35 PM Marc Reilly wrote:
> This series (against mfd-2.6/for-next) changes the mc13xxx driver to use
> regmap and adds I2C support.
> It has a compile dependency on regmap/for-next, as the spi driver uses the
> recently added pad_bits config field.

(bump).

Are these changes OK to go in?

Cheers,
Marc



> 
> Patch 2/4 has:
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Patch 4/4 has:
> Signed-off-by: Oskar Schirmer <oskar@scara.com>
> 
> Changes since:
> V4:
> - Fix compile error when CONFIG_OF enabled
> - Select REGMAP_I2C and REGMAP_SPI for appropriate drivers.
> 
> V3:
> - spi driver uses padded register format (reads should actually work now!)
> - mc13873 removed from I2C driver
> - fix memory leak on probe error
> 
> Cheers,
> Marc
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
