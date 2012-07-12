Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272Ab2GLV1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:27:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54094 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971Ab2GLV1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:27:04 -0400
MIME-Version: 1.0
In-Reply-To: <1342126544.22584.36.camel@x61.thuisdomein>
References: <1342126544.22584.36.camel@x61.thuisdomein>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 12 Jul 2012 23:26:42 +0200
Message-ID: <CAOiHx=nHf+rRGsw_pvSwxKn5VE9QYvCvy_p6j1ETf9HSHBgUNQ@mail.gmail.com>
Subject: Re: SPI: bcm63xx_dev_spi.h
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 July 2012 22:55, Paul Bolle <pebolle@tiscali.nl> wrote:
> 0) Commit b42dfed83d95a3c9e9cbd708f1993a7474abb79a ("spi: add Broadcom
> BCM63xx SPI controller driver") added drivers/spi/spi-bcm63xx.c to the
> mainline tree. That file includes bcm63xx_dev_spi.h.
>
> 1) bcm63xx_dev_spi.h is not part of the current tree, and, as far as I
> can tell, has actually never been part of the tree. So it seems that
> this driver could never be built using the mainline tree since it got
> added (in v3.4).
>
> 2) What's the current status of this header?

It currently sits in Ralf Baechle's queue and waits for the merge window:

http://git.linux-mips.org/?p=ralf/upstream-sfr.git;a=commit;h=435f920f35e90b4681e68002d2e2f6724b0c21b7


Jonas
