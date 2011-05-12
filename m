Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab1ELRfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:35:19 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:25550 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab1ELRfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:35:17 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1305221697!22617130!43
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Jamie Iles <jamie@jamieiles.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 12 May 2011 12:35:06 -0500
Subject: RE:  [RFC PATCH 0/3] Use basic_mmio_gpio to implement a generic
 gpio chip
Thread-Topic: RE:  [RFC PATCH 0/3] Use basic_mmio_gpio to implement a
 generic gpio chip
Thread-Index: AcwQyu8wyt0Z/Ow5ShmSpKVoULaywQ==
Message-ID: <0D753D10438DA54287A00B027084269764D2D09197@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4CHZOb4009349

On Wed May 05 2011, Jamie Iles wrote:
> This series is based on my earlier set of GPIO patches[1] to extend the
> basic_mmio_driver to be used as a library to implement a more generic gpio
> chip as initially implemented by Anton Vorontsov[2].
> 
> I've modified Anton's patch slightly to allow the bgpio_chip to be embedded
> into another structure and converted two drivers over - bt8xxgpio and
> langwell. bt8xxgpio seems to play nicely, but langwell not so much as it
> didn't previously use a gpio_chip per bank but it is a nice illustration.
> 
> Note that this is the same set of patches as attached in "Re: [PATCHv3 0/7]
> gpio: extend basic_mmio_gpio for different controllers" but reposted as a set
> of patches for convenience.
> 
> 1. http://article.gmane.org/gmane.linux.kernel/1124700
> 2. http://lkml.org/lkml/2011/4/19/401
> 
> Jamie Iles (3):
> basic_mmio_gpio: split into a gpio library and platform device
> gpio/bt8xxgpio: convert to use basic_mmio_gpio library
> gpio/langwell: convert to use basic_mmio_gpio library
> 
> drivers/gpio/Kconfig | 8 +
> drivers/gpio/Makefile | 1 +
> drivers/gpio/basic_mmio_gpio.c | 317 +++++++++++++++++++++------------------
> drivers/gpio/bt8xxgpio.c | 119 +++------------
> drivers/gpio/langwell_gpio.c | 253 +++++++++++++++----------------
> include/linux/basic_mmio_gpio.h | 55 +++++++
> 6 files changed, 381 insertions(+), 372 deletions(-)

Hello Jamie,

I was wondering on the status of this patch series, and Anton's for that matter.

I think I can convert the ep93xx gpio support to use this basic_mmio_gpio library
but would like to make sure I have seen all the relevant patches.  Is there any
plan on someone getting this into linux-next?

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
