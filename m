Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab0GIFEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 01:04:07 -0400
Received: from kroah.org ([198.145.64.141]:48890 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab0GIFEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 01:04:05 -0400
Date: Thu, 8 Jul 2010 22:04:01 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Paul Mundt <lethal@linux-sh.org>, Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: manual merge of the tty tree with the genesis tree
Message-ID: <20100709050401.GA6568@kroah.com>
References: <20100709134939.71170dae.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100709134939.71170dae.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 01:49:39PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> include/linux/serial_core.h between commit
> 75b93489b449db4a34f0424c72f51821d985f52f ("serial: add a new port type,
> found on some sh-mobile SoCs") from the genesis tree and commit
> 4286e9ca73813ee0ab5b0bd63b7eaefeb4994334 ("serial: max3107: Abstract out
> the platform specific bits") from the tty tree.
> 
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.

Thanks, as long as the numbers are sequencial, and they are, it should
be fine.  Alan was good in making the patch up correctly :)

thanks,

greg k-h
