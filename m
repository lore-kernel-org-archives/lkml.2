Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab0HJR3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 13:29:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467Ab0HJR24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 13:28:56 -0400
Date: Tue, 10 Aug 2010 10:10:42 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        Wang Qi <qi.wang@intel.com>, Wang Yong Y <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>, arjan@linux.intel.com
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Message-ID: <20100810171042.GD21220@suse.de>
References: <4C6131C2.4080101@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6131C2.4080101@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 08:02:26PM +0900, Masayuki Ohtak wrote:
> SPI driver of Topcliff PCH
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus. 
> Topcliff PCH has SPI I/F. Using this I/F, it is able to access system
> devices connected to SPI.
> 
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> ---
>  drivers/spi/Kconfig                    |   26 +
>  drivers/spi/Makefile                   |    4 +
>  drivers/spi/pch_spi.h                  |  177 +++
>  drivers/spi/pch_spi_main.c             | 1823 ++++++++++++++++++++++++++++++++
>  drivers/spi/pch_spi_platform_devices.c |   56 +

Any reason why you didn't run this by the Linux kernel SPI maintainers
and developers?  Please use the scripts/get_maintainer.pl script to find
the proper people if you don't want to look in the MAINTAINERS file to
find them that way.

thanks,

greg k-h
