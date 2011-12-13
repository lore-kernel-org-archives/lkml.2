Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1LMRdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 12:33:06 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37261 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753606Ab1LMRdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 12:33:03 -0500
X-Sasl-enc: BQAsjfChjNT9RzAFUAO4VeY0wIGbPIMQ+X41RrdrDL6E 1323797581
Date: Tue, 13 Dec 2011 09:15:11 -0800
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu
Subject: Re: [PATCH 1/3] kref: Inline all functions
Message-ID: <20111213171511.GA17096@kroah.com>
References: <20111210104341.592561407@chello.nl>
 <20111210104840.107647845@chello.nl>
 <20111212221159.GA27940@kroah.com>
 <1323768980.9082.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323768980.9082.6.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 10:36:20AM +0100, Peter Zijlstra wrote:
> On Mon, 2011-12-12 at 14:11 -0800, Greg KH wrote:
> > Nice, but this breaks the build:
> 
> Sorry about that, this one includes the missing include and just booted
> on my test-box.

Thanks, that worked.

> 
> ---
> Subject: kref: Inline all functions
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Sat Dec 10 11:29:57 CET 2011
> 
> These are tiny functions, there's no point in having them out-of-line.
> 
> Cc: adobriyan@gmail.com
> Cc: eric.dumazet@gmail.com
> Cc: mingo@elte.hu
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-8eccvi2ur2fzgi00xdjlbf5z@git.kernel.org
> ---
>  include/linux/kref.h |   80 +++++++++++++++++++++++++++++++++++++++---
>  lib/Makefile         |    2 -
>  lib/kref.c           |   97 ---------------------------------------------------
>  3 files changed, 76 insertions(+), 103 deletions(-)
> Index: linux-2.6/include/linux/kref.h
> ===================================================================

What's this stuff for, we aren't using cvs anymore :)

greg k-h
