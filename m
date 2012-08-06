Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2HFORB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:17:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40116 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab2HFOQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:16:58 -0400
MIME-Version: 1.0
In-Reply-To: <201208061402.22815.arnd@arndb.de>
References: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<201208061402.22815.arnd@arndb.de>
Date: Mon, 6 Aug 2012 16:16:57 +0200
Message-ID: <CABJ1b_S6jRW9P7ygs7LPztbx1zW-u=gD1kk0UYbgBrHdvsaOeA@mail.gmail.com>
Subject: Re: [PATCH 0/6] ARM: dove: DT support for Marvell Dove
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/12, Arnd Bergmann <arnd@arndb.de> wrote:
> This looks vert nice!
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Hi Arnd,

thanks for the ack!

> Has anyone tested it on cm-a510 and dove-db? Once we can reasonably
> assume that there are no regressions compared to using the board
> files, I think we can plan for removing the non-DT support in
> mach-dove. If it's been tested positively, that can well be at
> the same time as adding the DT support, otherwise I think we should
> wait a couple of releases while having both simultaneously.

Unfortunately, I has not (yet) been tested on cm-a510 nor dove-db but
from the status of the exisiting non-DT setup files I strongly doubt that
anyone is using current mainline kernel for mach-dove.

I suggest to keep non-DT support until we have pinctrl and gpiolib drivers
done. Thomas Petazzoni and I have been working on pinctrl that will be
posted in a few days and gpiolib driver needs some more cleanup but is
basically working. Until then I guess most of the other orion drivers have
DT support (eth and xor IIRC).

After that I am definitely fine with removing non-DT support although
there is neither DT support in u-boot installed on my CuBox nor
mach-dove support in mainline u-boot.

Sebastian
