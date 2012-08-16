Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab2HPN7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:59:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab2HPN7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:59:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH] ARM: LPC32xx: Provide DMA filter callbacks via platform data
Date: Thu, 16 Aug 2012 13:59:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux@arm.linux.org.uk, artem.bityutskiy@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org
References: <1345122935-22115-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1345122935-22115-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208161359.21276.arnd@arndb.de>
X-Provags-ID: V02:K0:S9z+5bQ+PTibr+fO5C+D+DJnFfLtWw4blxkvsG9rbc0
 pL122XTzXszklIYlxD/DAitfpPxXD5KQIxHaTFvw/9jX/nDWwp
 fNI2Xl92UsevB9OR2mpZkf2Rf8VqMItMS6rSIYo4fGKzi0jFTx
 cXVwoWHzW/WBxCONC+oRb1MlbhcjIB+TWgljeX2D0i8uVZcX9g
 SrTsJKwwvurSSndmCxrLp8tu1e4GTbeIy1Q+zjpfFAaKl9lhvc
 16J9DzXAxeNFHzgtZLMrsiQFdrRAOBHMKDXrK2KZuYlFDz2vUE
 otOH32wUTKvv75BvKqlI1CKPkW1obA9E0rs2G5nzKA30DC5g+9
 kQOWAYjX5PGUZ3UH0WhY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Roland Stigge wrote:
> The SLC and MLC NAND drivers now need their dma_filter callbacks via platform
> data to make them independent of single DMA engine drivers.
> 
> (This also helps fixing build errors of the SLC and MLC drivers when building
> as modules because direct access to AMBA dma filter functions isn't available
> via export.)
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Yes, this looks right.

Acked-by: Arnd Bergmann <arnd@arndb.de>

Once we have proper DT bindings for the DMA channels, we can hopefully
get rid of the auxdata again.

	Arnd
