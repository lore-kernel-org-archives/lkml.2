Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab2LFOEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:04:36 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37573 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab2LFOEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:04:34 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: Remove SPI_BUFSIZ restriction on spi_write_then_read()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20121206053732.GD10867@opensource.wolfsonmicro.com>
References: <1354420465-29315-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20121206000026.A620D3E0E22@localhost> <20121206053732.GD10867@opensource.wolfsonmicro.com>
Date: Thu, 06 Dec 2012 14:04:27 +0000
Message-Id: <20121206140427.8E5673E089D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2012 14:37:33 +0900, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Dec 06, 2012 at 12:00:26AM +0000, Grant Likely wrote:
> 
> > Looks good to me. Probably 3.9 material though.
> 
> > Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> Hrm, I'd be inclined to apply it now - it's isolated enough that it can
> be reverted if it explodes and we have the -rc cycle to notice any
> problems.

Alright, applied. I've also merged in your spi-next tree. Let me know if
that causes problems because it needs to be rebased.

g.


-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
