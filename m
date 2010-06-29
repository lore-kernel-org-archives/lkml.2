Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab0F2FC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 01:02:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56123 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0F2FCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 01:02:25 -0400
MIME-Version: 1.0
In-Reply-To: <20100629132907.f857600d.sfr@canb.auug.org.au>
References: <20100629132907.f857600d.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 28 Jun 2010 22:02:02 -0700
X-Google-Sender-Auth: aTc4ggiYB43G0e1n7Odsfhcuv54
Message-ID: <AANLkTilbN3BBwmF1lRFrMLyNLGcLdwN6vUSX9HEhvj1u@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the spi tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ernst Schwab <eschwab@online.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 8:29 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> drivers/mmc/host/mmc_spi.c: In function 'mmc_spi_readbytes':
> drivers/mmc/host/mmc_spi.c:185: error: implicit declaration of function 'spi_sync_locked'
> drivers/mmc/host/mmc_spi.c: In function 'mmc_spi_request':
> drivers/mmc/host/mmc_spi.c:1088: error: implicit declaration of function 'spi_bus_lock'
> drivers/mmc/host/mmc_spi.c:1101: error: implicit declaration of function 'spi_bus_unlock'
>
> Caused by commit f0168ff4069fba07fdd4b05aa19f283171c8d265 ("spi/mmc_spi:
> mmc_spi adaptations for SPI bus locking API").  Maybe updates to another
> file were missed?

Yup, bad tree on my part.  Reset back to 2.6.35-rc3 now.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
