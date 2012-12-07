Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424255Ab2LGDlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 22:41:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42908 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1424226Ab2LGDlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 22:41:49 -0500
Date: Fri, 7 Dec 2012 12:41:41 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: Remove SPI_BUFSIZ restriction on
 spi_write_then_read()
Message-ID: <20121207034140.GB26070@opensource.wolfsonmicro.com>
References: <1354420465-29315-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20121206000026.A620D3E0E22@localhost>
 <20121206053732.GD10867@opensource.wolfsonmicro.com>
 <20121206140427.8E5673E089D@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206140427.8E5673E089D@localhost>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 02:04:27PM +0000, Grant Likely wrote:

> Alright, applied. I've also merged in your spi-next tree. Let me know if
> that causes problems because it needs to be rebased.

No problem - do you just want to take over the SPI tree again or should
I carry on applying things?
