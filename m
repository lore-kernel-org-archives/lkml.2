Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1FEImC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 04:42:02 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:35807 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab1FEImA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 04:42:00 -0400
X-Greylist: delayed 2785 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jun 2011 04:41:59 EDT
Date: Sun, 5 Jun 2011 10:54:58 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: reorganize drivers
Message-ID: <20110605075458.GA2712@tarshish>
References: <20110605071725.26517.11573.stgit@ponder>
 <BANLkTinoEQf2a65KwQZOVK_4H9DSfqybjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinoEQf2a65KwQZOVK_4H9DSfqybjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

On Sun, Jun 05, 2011 at 01:13:28PM +0530, Jassi Brar wrote:
> On Sun, Jun 5, 2011 at 12:48 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > [repost: I had a typo on the spi-devel-general mailing list address]
> >
> > Sort the SPI makefile and enforce the naming convention spi_*.c for
> > spi drivers.

[snip]

> Though the spi_ prefix seems redundant considering the files are in
> 'spi' directory.
> Just a thought, no objection.

When looking at the list of loaded modules (e.g. in an Oops message), the name 
"spi_xilinx" is much more meaningful than just "xilinx", for example.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
