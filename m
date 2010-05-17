Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab0EQSUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:20:30 -0400
Received: from kroah.org ([198.145.64.141]:34178 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab0EQSUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:20:24 -0400
Date: Mon, 17 May 2010 11:01:56 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: manual merge of the staging-next tree with the rr
 tree
Message-ID: <20100517180156.GD16419@kroah.com>
References: <20100517154452.93fbac66.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517154452.93fbac66.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 03:44:52PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/rtl8187se/r8180_core.c between commit
> 9080984577cb3e04226d94c8f733534b60541f01
> ("param:remove-useless-writable-charp") from the rr tree and commit
> bbfb56520c8da666383c08220985495ff918d4ad ("") from the staging-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Looks good, thanks.

greg k-h
