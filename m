Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab0HDCJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:09:29 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:45526 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079Ab0HDCJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:09:26 -0400
Subject: Re: linux-next: build warning after merge of the nfs tree
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100804113214.62913199.sfr@canb.auug.org.au>
References: <20100804113214.62913199.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 22:09:21 -0400
Message-ID: <1280887762.24669.25.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 7 msgs/h 2 sum rcpts/h 11 sum msgs/h 2 total rcpts 799 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: C3AB73B0C8E43B018FFBF08E1D1CA4D21441D6E1
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 309 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 11:32 +1000, Stephen Rothwell wrote:
> Hi Trond,
> 
> After merging the nfs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> fs/nfs/file.c: In function 'nfs_file_flush':
> fs/nfs/file.c:211: warning: unused variable 'ctx'
> 
> Introduced by commit 7f09dcf61bc211b0a71a5caa15ceb9b7bbec2126 ("NFS: Fix
> up the fsync code").

Hi Stephen,

Sorry. I've fixed the above warning up in today's tree.

Cheers
  Trond

