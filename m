Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab1FPRbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:31:32 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:50302 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab1FPRbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:31:31 -0400
Subject: Re: linux-next: build warnings after merge of the nfs tree
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Jun 2011 13:31:26 -0400
In-Reply-To: <20110616133847.1ba62bab.sfr@canb.auug.org.au>
References: <20110616133847.1ba62bab.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308245489.10167.4.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 3 sum msgs/h 1 total rcpts 1452 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 36645B44AD8F6D635458F970FBB388A4F40FFB45
X-UiO-SPAM-Test: remote_host: 141.212.112.136 spam_score: -49 maxlevel 80 minaction 2 bait 0 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 13:38 +1000, Stephen Rothwell wrote: 
> Hi Trond,
> 
> After merging the nfs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
> 
> fs/nfs/pnfs.h:379:13: warning: 'pnfs_pageio_init_read' defined but not used
> fs/nfs/pnfs.h:384:13: warning: 'pnfs_pageio_init_write' defined but not used
> 
> (lots of times)
> 
> Introduced by commit cb679cdd50a8 ("NFS: Cleanup of the nfs_pageio code
> in preparation for a pnfs bugfix").  "inline" is missing.
> 

Sorry about that. It should be fixed now...

