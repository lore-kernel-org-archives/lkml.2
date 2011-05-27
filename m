Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab1E0DbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 23:31:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59224 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1E0DbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 23:31:02 -0400
Date: Thu, 26 May 2011 21:31:00 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ben Dooks <ben@simtec.co.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] spi: tle620x: add missing device_remove_file()
Message-ID: <20110527033100.GL5032@ponder.secretlab.ca>
References: <1305117545.6324.3.camel@phoenix>
 <4DCB9985.2050100@simtec.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCB9985.2050100@simtec.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 09:25:41AM +0100, Ben Dooks wrote:
> On 11/05/11 13:39, Axel Lin wrote:
> >This patch includes below fixes:
> >1. Add missing device_remove_file for dev_attr_status_show in tle62x0_remove.
> >2. Fix tle62x0_probe error handling:
> >    Currently, if the error happens when ptr>  0, gpio_attrs[0] is not
> >    properly remove.
> >
> >Signed-off-by: Axel Lin<axel.lin@gmail.com>
> Acked-by: Ben Dooks <ben-linux@fluff.org>

Applied, thanks.

g.

