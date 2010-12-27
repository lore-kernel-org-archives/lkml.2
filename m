Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab0L0Wzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 17:55:36 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:36810 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0L0Wze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 17:55:34 -0500
Subject: Re: linux-next: Tree for December 27 (drivers/target)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101227115755.ffcdfc4f.randy.dunlap@oracle.com>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
	 <20101227115755.ffcdfc4f.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 27 Dec 2010 14:49:39 -0800
Message-Id: <1293490179.4649.208.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-27 at 11:57 -0800, Randy Dunlap wrote:
> On Mon, 27 Dec 2010 17:04:51 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > [The mirroring on kernel.org is running slowly]
> > 
> > Changes since 20101221:
> > 
> > Linus' tree lost its build failure.
> 
> 
> Hi Nick,
> 
> Please test building target code when CONFIG_BLOCK is not enabled.
> 
> When CONFIG_BLOCK is not enabled, drivers/target/ gets a boat load of build errors.
> 
> Should TCM_IBLOCK depend on BLOCK?  That fixes lots of the build errors,
> but not all of them.
> 
> 
> The header file include/target/target_core_base.h uses struct queue_limits,
> so it should #include <linux/blkdev.h>.
> 
> 

Added the missing include here:

target: Add linux/blkdev.h include in target_core_base.h
http://git.kernel.org/?p=linux/kernel/git/nab/linux-next.git;a=commitdiff;h=e8bd07d3a525e71b424d308fc5084b89a6456bb2

Thanks Randy!

--nab

