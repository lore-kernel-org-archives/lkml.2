Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab0D0PPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:15:38 -0400
Received: from kroah.org ([198.145.64.141]:44786 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab0D0POt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:14:49 -0400
Date: Tue, 27 Apr 2010 08:14:15 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vijay Kumar <vijaykumar@bravegnu.org>
Subject: Re: linux-next: manual merge of the bkl-ioctl tree with the
 staging-next tree
Message-ID: <20100427151415.GC7653@kroah.com>
References: <20100427144804.cbfa9564.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100427144804.cbfa9564.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 02:48:04PM +1000, Stephen Rothwell wrote:
> Hi Frédéric,
> 
> Today's linux-next merge of the bkl-ioctl tree got a conflict in
> drivers/staging/poch/poch.c between commit
> ba7d84da197c348efa2b2984a848e0fbccd4b9b0 ("Staging: Remove staging/poch")
> from the staging-next tree and commit
> 1dd97d3d546aa14db7efa5366b21d1336b91379e ("Rename 'struct
> file_operations' 'ioctl' fn pointer to 'bkl_ioctl'") from the bkl-ioctl
> tree.
> 
> The former just removed the file, so I did as well.

That's the correct fix :)

thanks,

greg k-h
