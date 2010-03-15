Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965822Ab0COXqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:46:44 -0400
Received: from kroah.org ([198.145.64.141]:45240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965013Ab0COXql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:46:41 -0400
Date: Mon, 15 Mar 2010 16:46:25 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] sysdev: the cpu probe/release attributes should be
 sysdev_class_attributes
Message-ID: <20100315234625.GA12575@kroah.com>
References: <20100316103332.ade0b5d9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316103332.ade0b5d9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 10:33:32AM +1100, Stephen Rothwell wrote:
> This fixes these warnings:
> 
> drivers/base/cpu.c:264: warning: initialization from incompatible pointer type
> drivers/base/cpu.c:265: warning: initialization from incompatible pointer type
> 
> Cc: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/base/cpu.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> Hi Greg,
> 
> Could you pleas send this on to Linuse as this is now a bug in mainline.

Will do, thanks so much for fixing this up correctly.

greg k-h
