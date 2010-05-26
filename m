Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab0EZGqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:46:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50144 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934121Ab0EZGqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:46:51 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: miklos@szeredi.hu, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20100526114406.d3a68d1f.sfr@canb.auug.org.au> (message from
	Stephen Rothwell on Wed, 26 May 2010 11:44:06 +1000)
Subject: Re: linux-next: build failure after merge of the fuse tree
References: <20100526114406.d3a68d1f.sfr@canb.auug.org.au>
Message-Id: <E1OHAO6-0007wV-BK@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 May 2010 08:46:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, 26 May 2010, Stephen Rothwell wrote:
> After merging the fuse tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> ERROR: "generic_pipe_buf_map" [fs/fuse/fuse.ko] undefined!
> ERROR: "generic_pipe_buf_confirm" [fs/fuse/fuse.ko] undefined!
> ERROR: "generic_pipe_buf_get" [fs/fuse/fuse.ko] undefined!
> ERROR: "generic_pipe_buf_unmap" [fs/fuse/fuse.ko] undefined!
> ERROR: "generic_pipe_buf_release" [fs/fuse/fuse.ko] undefined!
> 
> Caused by commit c3021629a0d820247ee12b6c5192a1d5380e21c6 ("fuse: support
> splice() reading from fuse device").

Oops, missed one patch, and forgot to test with modular kernel.  It's
now fixed in the for-next branch.

Thanks for letting me know.

Miklos
