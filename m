Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab2B1Iit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:38:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36816 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524Ab2B1Iir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:38:47 -0500
Date: Tue, 28 Feb 2012 08:38:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mattias NILSSON <mattias.i.nilsson@stericsson.com>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: RFC: what do we do with system controllers?
Message-ID: <20120228083833.GB18045@n2100.arm.linux.org.uk>
References: <CACRpkdY1W-RGE0JL4Sx5UcPY-EGieu8vo7H0fp9xyXtegpaaKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY1W-RGE0JL4Sx5UcPY-EGieu8vo7H0fp9xyXtegpaaKw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 06:48:12AM +0100, Linus Walleij wrote:
> Mainly addressed to Greg but anyone is welcome to join the
> discussion...
> 
> Several ARM platforms have system controllers. In this I
> include all custom terminology such as:
> 
> - System Control
> - Chip Controller
> - Core Module control registers
> - Power Reset Control Management Units
> - Multimedia Communications Port

Why do you include this?  If you include this, you should include things
like SSP/SPI ports, I2C and other such buses.
