Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab0IUBbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 21:31:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab0IUBbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 21:31:12 -0400
Date: Tue, 21 Sep 2010 11:31:01 +1000
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 0/7 v3] overlay filesystem prototype
Message-ID: <20100921113101.3bde59bd@notabene>
In-Reply-To: <20100920180404.939991832@szeredi.hu>
References: <20100920180404.939991832@szeredi.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 20:04:04 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> Here's an updated patch series.
> 
> For now I reverted Neil's revalidation patch.  Not requiring strict
> read-only would make sense for just trying it out and experimenting.
> But for real uses, I'm not sure...

:-)

I think you significantly reduce the value by insisting on read-only but as
this is purely a theoretical perspective at the moment (I have no concrete
use-case) I won't push it.

I had another patch I was working on which caused overlayfs to keep negative
dentries in upperdentry or lowerdentry rather than just setting them to
NULL.  This would allow revalidation to notice objects appearing in the
underlying filesystem.  I guess you won't want that now .... I think it made
some of the code a bit neater, but I never finished it so I cannot be sure of
the overall effect.

I'm curious as to why upperdentry is now called __upperdentry - it isn't
clear from a quick reading..

Thanks,
NeilBrown

