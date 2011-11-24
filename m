Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1KXTOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 14:14:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:56056 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab1KXTOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 14:14:22 -0500
Subject: Re: [PATCH 1/1] SPI: disable CONFIG_SPI_FSL_ESPI=m build
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1322131298-21511-1-git-send-email-jslaby@suse.cz>
Date: Thu, 24 Nov 2011 13:12:08 -0600
Cc: grant.likely@secretlab.ca, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <5C7165B8-7ED5-444B-BF8B-DA049A432E6D@kernel.crashing.org>
References: <1322131298-21511-1-git-send-email-jslaby@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 24, 2011, at 4:41 AM, Jiri Slaby wrote:

> When spi_fsl_espi is chosen to be built as a module, there is a build
> error because we test only CONFIG_SPI_FSL_ESPI in declaration of
> struct mpc8xxx_spi in drivers/spi/spi_fsl_lib.h. Also some called
> functions are not exported.
> 
> So we forbid CONFIG_SPI_FSL_ESPI to be tristate here.
> 
> The error looks like:
> drivers/spi/spi_fsl_espi.c: In function 'fsl_espi_bufs':
> drivers/spi/spi_fsl_espi.c:232: error: 'struct mpc8xxx_spi' has no member named 'len'
> ...
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> ---
> drivers/spi/Kconfig |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Kumar Gala <galak@kernel.crashing.org>

- k