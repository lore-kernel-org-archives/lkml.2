Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030624Ab2LGOEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:04:48 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40898 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030510Ab2LGOEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:04:47 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: Remove SPI_BUFSIZ restriction on spi_write_then_read()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20121207034140.GB26070@opensource.wolfsonmicro.com>
References: <1354420465-29315-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20121206000026.A620D3E0E22@localhost> <20121206053732.GD10867@opensource.wolfsonmicro.com> <20121206140427.8E5673E089D@localhost> <20121207034140.GB26070@opensource.wolfsonmicro.com>
Date: Fri, 07 Dec 2012 14:04:34 +0000
Message-Id: <20121207140434.64B5D3E0B87@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2012 12:41:41 +0900, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Dec 06, 2012 at 02:04:27PM +0000, Grant Likely wrote:
> 
> > Alright, applied. I've also merged in your spi-next tree. Let me know if
> > that causes problems because it needs to be rebased.
> 
> No problem - do you just want to take over the SPI tree again or should
> I carry on applying things?

Yes, please keep doing what you're doing! It's a huge help.

Whenever I sit down to do patch maintenance, I'll pull in your tree
first. As long as your tree doesn't get rebased then that should work
well. I also promise to not rebase my tree without talking to you first
so you can pull in mine before applying more patches on top.

It's a huge help to be reading through the mailing list and be able to
ignore any messages that I've seen you've already replied to or applied.

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
