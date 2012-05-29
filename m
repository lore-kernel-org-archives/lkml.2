Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2E2PlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 11:41:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2E2PlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 11:41:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH 1/2] serial/8250: Add LPC3220 standard UART type
Date: Tue, 29 May 2012 15:39:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
References: <1338282570-19799-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1338282570-19799-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205291539.44705.arnd@arndb.de>
X-Provags-ID: V02:K0:QDQBI1OHdpUaX482syglL7c5O9eaa48otwgDAC+xl7X
 tuhUG2NwZEzac4pGOrMC7duP/yettTkX9JIkMYG2ALFarS2svA
 3bA7bZlZ4s5z6KeHPny57ZPKcu8eMi5RA36almpyu1Lpjylbg+
 SxCzR95sR5acixC+CC89KOQWOh+wPC5BHnKvS/uoC2HIC9siSz
 /4onflenxr6qpOBxhJphHD44mErmHqy2jB+uHkLS6Jp+mbXXpz
 Gxn+6yGFMOh+bq5oLDhiapoezORqpJgzoZm7IXGWsywMUXfi7v
 go9p2cF8NskoEGdoGA6jd8A4fB4gRPes2mmgfUZX48fu8EhkkZ
 BdXa7eTvB2tXzXmAH3p8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2012, Roland Stigge wrote:
> 
> LPC32xx has "Standard" UARTs that are actually 16550A compatible but have
> bigger FIFOs. Since the already supported 16X50 line still doesn't match here,
> we agreed on adding a new type.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
