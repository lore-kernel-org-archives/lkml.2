Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab1DTUld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:41:33 -0400
Received: from kroah.org ([198.145.64.141]:40284 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab1DTUlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:41:32 -0400
Date: Wed, 20 Apr 2011 13:31:17 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] gma500: add the ability to request backed space or
 not
Message-ID: <20110420203117.GA14141@kroah.com>
References: <20110419142432.16479.89255.stgit@localhost.localdomain>
 <20110419142658.16479.59689.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419142658.16479.59689.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 03:27:10PM +0100, Alan Cox wrote:
> We will will need this for doing a GEM allocator. It should also avoid any
> crashes with the current code if the stolen area is too small.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

What tree did you make this against?

When applying it, I get the following error from git:

Applying: gma500: add the ability to request backed space or not
/home/linux/linux/work/staging-2.6/.git/rebase-apply/patch:47: trailing whitespace.
	
error: patch failed: drivers/staging/gma500/psb_fb.c:479
error: drivers/staging/gma500/psb_fb.c: patch does not apply
error: patch failed: drivers/staging/gma500/psb_gtt.c:972
error: drivers/staging/gma500/psb_gtt.c: patch does not apply
error: patch failed: drivers/staging/gma500/psb_gtt.h:105
error: drivers/staging/gma500/psb_gtt.h: patch does not apply
Patch failed at 0001 gma500: add the ability to request backed space or not

Care to redo this series and resend them so I can apply them?

thanks,

greg k-h
