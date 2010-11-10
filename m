Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0KJSkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:40:09 -0500
Received: from kroah.org ([198.145.64.141]:46739 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab0KJSkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:40:07 -0500
Date: Wed, 10 Nov 2010 10:40:04 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Dan Carpenter <error27@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the  tree
Message-ID: <20101110184004.GB15089@kroah.com>
References: <20101110132408.67f73665.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110132408.67f73665.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 01:24:08PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/intel_sst/intel_sst_app_interface.c between commits from
> the staging.current tree and commit
> d0f40c5041f9c48afbd8f7fbf8a5faa9e5dbd39a ("Staging: intel_sst: Use
> pr_fmt, fix misspellings") from the staging tree.
> 
> I have just ignored the changes from the staging tree for today.

Thanks, that works, when these patches go to Linus I'll handle the
merge.

greg k-h
