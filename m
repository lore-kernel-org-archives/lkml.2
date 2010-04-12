Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0DLVUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 17:20:12 -0400
Received: from quartz.orcorp.ca ([139.142.54.143]:50023 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab0DLVUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 17:20:10 -0400
Date: Mon, 12 Apr 2010 15:20:05 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: Extend physmap_of to let the device tree specify
	the parition probe
Message-ID: <20100412212005.GX15629@obsidianresearch.com>
References: <20100309192756.GC30462@obsidianresearch.com> <1270543478.6754.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270543478.6754.10.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 11:44:38AM +0300, Artem Bityutskiy wrote:
> On Tue, 2010-03-09 at 12:27 -0700, Jason Gunthorpe wrote:
> > This is to support custom partitioning schemes for embedded PPC. To use
> > define your own mtd_part_parser and then add something like:
> >    linux,part-probe = "my_probe", "cmdlinepart";
> > To the board's dts file.
> > 
> > If linux,part-probe is not specified then this behaves the same as before.
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
> Taken to my l2-mtd-2.6.git / dunno

Thanks Artem, not sure what that means? Do you need anything
additional from me?

Jason
