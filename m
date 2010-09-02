Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0IBDcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:32:25 -0400
Received: from kroah.org ([198.145.64.141]:45663 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab0IBDcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:32:24 -0400
Date: Wed, 1 Sep 2010 20:29:11 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, Jason Baron <jbaron@redhat.com>
Subject: Re: linux-next: build warning after merge of the driver-core tree
Message-ID: <20100902032911.GA28546@kroah.com>
References: <20100902131835.6a8f8c83.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902131835.6a8f8c83.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 01:18:35PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> kernel/params.c: In function 'parse_args':
> kernel/params.c:200: warning: passing argument 2 of 'snprintf' makes integer from pointer without a cast
> include/linux/kernel.h:203: note: expected 'size_t' but argument is of type 'char *'
> 
> Caused by commit d1aa8e2ab38942b21d543611d4f829597d8791d4 ("Dynamic
> Debug: Introduce global fake module param module.ddebug").
> 
> Some warnings should not be ignored ... and it does make me wonder how
> much testing this has had ...

Odd.  Thomas and Jason, care to fix this up please?

thanks,

greg k-h
