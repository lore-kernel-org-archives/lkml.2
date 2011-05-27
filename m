Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1E0NyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:54:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258Ab1E0NyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:54:07 -0400
Date: Fri, 27 May 2011 15:54:05 +0200
From: Jan Kara <jack@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jan Kara <jack@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Subject: Re: linux-next: build warning after merge of the final tree (ext3
 tree related)
Message-ID: <20110527135405.GA18230@quack.suse.cz>
References: <20110527165906.97310c97.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527165906.97310c97.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 27-05-11 16:59:06, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (gcc 4.5.2, powerpc
> ppc44x_defconfig) produced this warning:
> 
> fs/ext3/inode.c: In function 'ext3_get_blocks_handle':
> fs/ext3/inode.c:976:8: warning: array subscript is below array bounds
> 
> Introduced by commit 20024a79a97b ("ext3: Add fixed tracepoints").
  Thanks, fixed (it was a real bug that could have been triggered on
a corrupted filesystem).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
