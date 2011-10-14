Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab1JNI4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 04:56:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50126 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1JNI4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 04:56:39 -0400
Subject: Re: [PATCH] mtd: rename the redboot module to RedBoot
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Oct 2011 11:56:07 +0300
In-Reply-To: <20111003222346.5ac48654@queued.net>
References: <20111003222346.5ac48654@queued.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318582575.12351.74.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 22:23 -0700, Andres Salomon wrote:
> parse_mtd_partitions takes a list of partition types; if the driver
> isn't loaded, it attempts to load it, and then it grabs the partition
> parser.  For redboot, the module name is "redboot.ko", while the parser
> name is "RedBoot".  Since modprobe is case-sensitive, attempting to
> modprobe "RedBoot" will never work.  I suspect the embedded systems that
> make use of redboot just always manually loaded redboot prior to loading
> their specific nand chip drivers (or statically compiled it in).
> 
> Alternatives include renaming the parser to "redboot", changing
> parse_mtd_partitions to accept pairs of strings, or changing modprobe
> to be case-insensitive.  Renaming the module seems like the easy,
> obvious solution. :)
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/mtd/Makefile  |    2 +-
>  drivers/mtd/RedBoot.c |  315 +++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/mtd/redboot.c |  315 -------------------------------------------------
>  3 files changed, 316 insertions(+), 316 deletions(-)
>  create mode 100644 drivers/mtd/RedBoot.c
>  delete mode 100644 drivers/mtd/redboot.c

Could you please use MODULE_ALIAS(RedBoot) instead?

-- 
Best Regards,
Artem Bityutskiy

