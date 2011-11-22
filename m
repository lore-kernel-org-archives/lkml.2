Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab1KVQMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:12:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51803 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab1KVQMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:12:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: michael.hennerich@analog.com
Subject: Re: [PATCH 2/2] misc: ad525x_dpot: Add support for SPI module device table matching
Date: Tue, 22 Nov 2011 16:11:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: greg@kroah.com, device-drivers-devel@blackfin.uclinux.org,
        drivers@analog.com, linux-kernel@vger.kernel.org
References: <1321610711-12507-1-git-send-email-michael.hennerich@analog.com> <1321610711-12507-2-git-send-email-michael.hennerich@analog.com>
In-Reply-To: <1321610711-12507-2-git-send-email-michael.hennerich@analog.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111221611.19190.arnd@arndb.de>
X-Provags-ID: V02:K0:HxNs0tAx4ODlRDfjFNs4P3AMrWTsWvdPdf9ucvLYgTh
 uHWtlB2nAazTczPYrTEzCyB+UByl3n1w3nqkzxOzZ2vu1pnqeK
 4BVzBSFj/UhRFfPivUK4SrJ16cAclqf2sVmbOzOxLJLk1ndgVO
 r4/XzfoWrimAU2FjkgBWW2BlEQkCvXhU+SWaXt1u+NsH2BcMd4
 ltfy7VPWnKa14e6moDB/B4rre9zgwJwUZlSE4wZQMaJWItMYyi
 ChfCNyPBHtRHwaccRFawBQJ64eVTPHXdYu/APYNDBiLFQr8m5n
 sqkD/L1TRrN6r0C33NkS41Lb693Fh/DGdu6x2Q6CaGNj2YP5U/
 rNYmQUeTwpQbTXv5DF10=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 November 2011, michael.hennerich@analog.com wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Passing device name via platform data, is a leftover from times where
> SPI module device table matching was not existent.
> 
> * Add id_table and remove old mechanism.
> (To my knowledge no intree boards affected)
> * Miscellaneous other cleanup.

The patch looks good to me, but please don't do "miscelaneous other cleanup"
in the same patch. I think doing cleanups while you change a driver is
a good idea, just do the extra step to split those out into a cleanup
patch and describe what you do, just like you have split out the bug fix.

	Arnd
