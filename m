Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab0EGQwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:52:09 -0400
Received: from kroah.org ([198.145.64.141]:41506 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab0EGQwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:52:07 -0400
Date: Fri, 7 May 2010 09:40:12 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: linux-next: manual merge of the staging-next tree with Linus'
 tree
Message-ID: <20100507164012.GA21927@kroah.com>
References: <20100507152108.49975171.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507152108.49975171.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 03:21:08PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/hv/hv.c between commit
> fa8ad0257ea256381126ecf447694622216c600f ("Staging: hv: Fix up memory
> leak on HvCleanup") from Linus' tree and commit
> eda95eef15e86e100aaeeec4e8ed3eb1eced2967 ("Staging: hv: rename Hv.c to
> hv.c") from the staging-next tree.
> 
> I used the staging-next version.

Yes, that's the proper version, thanks.

greg k-h
