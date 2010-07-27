Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab0G0Erm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 00:47:42 -0400
Received: from kroah.org ([198.145.64.141]:38105 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab0G0Erk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 00:47:40 -0400
Date: Mon, 26 Jul 2010 21:47:05 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: linux-next: manual merge of the tty tree with the genesis tree
Message-ID: <20100727044705.GA16378@kroah.com>
References: <20100727143430.05c018fc.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727143430.05c018fc.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 02:34:30PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> include/linux/serial_core.h between commit
> 75b93489b449db4a34f0424c72f51821d985f52f ("serial: add a new port type,
> found on some sh-mobile SoCs") from the genesis tree and commit
> c3190cf68dfc58c33de0fd59b919cbb864acbba4 ("hsu: driver for Medfield High
> Speed UART device") from the tty tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks, the fix looks fine.

greg k-h
