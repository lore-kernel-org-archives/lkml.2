Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab2ENBfP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 21:35:15 -0400
Received: from ozlabs.org ([203.10.76.45]:45454 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab2ENBfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 21:35:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the akpm tree with the rr tree
In-Reply-To: <20120510185155.47d24f37951786b64af97868@canb.auug.org.au>
References: <20120510185155.47d24f37951786b64af97868@canb.auug.org.au>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 14 May 2012 10:59:34 +0930
Message-ID: <877gwfv9c1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 18:51:55 +1000, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got conflicts in
> kernel/lglock.c, include/linux/lglock.h, fs/namespace.c and fs/internal.h
> between various commits from the rr tree and commit "brlocks/lglocks:
> cleanups" from the akpm tree.
> 
> The akpm tree patch seems to be a merge of the rr tree commits, so I
> dropped the akpm tree patch.

Al said he'd take them, so I dropped mine now too.

Thanks,
Rusty.

