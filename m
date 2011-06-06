Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1FFIAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:00:54 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:46797 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795Ab1FFIAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:00:53 -0400
X-Auth-Info: amS9MIzlaj0vQumlRQ2yyxuUSc0HGefMDtEskPDytyI=
Date: Mon, 6 Jun 2011 10:00:45 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, dzu@denx.de
Subject: Re: [PATCH 1/2] misc/eeprom: add driver for 93xx46 EEPROMs over
 GPIO
Message-ID: <20110606100045.3accb6e8@wker>
In-Reply-To: <4DDCCC82.90604@cam.ac.uk>
References: <1306252963-20746-1-git-send-email-agust@denx.de>
	<4DDCCC82.90604@cam.ac.uk>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 10:31:46 +0100
Jonathan Cameron <jic23@cam.ac.uk> wrote:

> On 05/24/11 17:02, Anatolij Gustschin wrote:
> > 93xx46 EEPROMs can be connected using GPIO lines. Add a generic
> > 93xx46 EEPROM driver using common GPIO API for such configurations.
> > A platform is supposed to register appropriate 93xx46 gpio device
> > providing GPIO interface description and using this driver
> > read/write/erase access to the EEPROM chip can be easily done
> > over sysfs files.
> Could you explain why this makes more sense than an spi driver and
> use of spi_gpio ?
> 
> It's microwire compatible according to random google provided datasheet,
> which iirc is a particular form of spi (half duplex, spi mode 0 according
> to wikipedia)
> 
> That would give us a more generally useful driver.

Reworked the driver to be an spi driver using spi_gpio so
it is more generally useful driver now. spi_gpio driver
needs some fixes, though. I'll submit the new driver soon.
