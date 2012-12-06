Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2LFFhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 00:37:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33932 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818Ab2LFFhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 00:37:39 -0500
Date: Thu, 6 Dec 2012 14:37:33 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: Remove SPI_BUFSIZ restriction on
 spi_write_then_read()
Message-ID: <20121206053732.GD10867@opensource.wolfsonmicro.com>
References: <1354420465-29315-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20121206000026.A620D3E0E22@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206000026.A620D3E0E22@localhost>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 12:00:26AM +0000, Grant Likely wrote:

> Looks good to me. Probably 3.9 material though.

> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Hrm, I'd be inclined to apply it now - it's isolated enough that it can
be reverted if it explodes and we have the -rc cycle to notice any
problems.
