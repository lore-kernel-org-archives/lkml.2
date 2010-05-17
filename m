Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0EQSVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:21:11 -0400
Received: from kroah.org ([198.145.64.141]:34171 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab0EQSUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:20:23 -0400
Date: Mon, 17 May 2010 11:01:15 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: Re: linux-next: build warning after merge of the usb tree
Message-ID: <20100517180115.GB16419@kroah.com>
References: <20100517160958.b5208a24.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517160958.b5208a24.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 04:09:58PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the usb tree, today's linux-next build (powerpc
> ppc44x_defconfig) produced this warning:
> 
> drivers/usb/core/usb.c:596: warning: 'match_device' defined but not used
> 
> Introduced by commit c8a3789b05e2ed43d8fd98934edbf66587cd3f96 ("USB:
> remove usb_find_device") which removed the last user of this function.

Thanks, Ming just sent me a patch to resolve this, I'll go apply it now.

greg k-h
