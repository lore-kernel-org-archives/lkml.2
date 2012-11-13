Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2KMHDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:03:11 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:57750 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2KMHDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:03:09 -0500
Date: Tue, 13 Nov 2012 11:03:05 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 1/7] procfs: Add ability to plug in auxiliary fdinfo
 providers
Message-ID: <20121113070305.GB6511@moon>
References: <20121112101440.665694060@openvz.org>
 <20121112101845.678229459@openvz.org>
 <20121112164022.1bc3dd4e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121112164022.1bc3dd4e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 04:40:22PM -0800, Andrew Morton wrote:
> >
> > --- linux-2.6.git.orig/include/linux/fs.h
> > +++ linux-2.6.git/include/linux/fs.h
> > @@ -1517,6 +1517,8 @@ struct block_device_operations;
> >  #define HAVE_COMPAT_IOCTL 1
> >  #define HAVE_UNLOCKED_IOCTL 1
> >  
> > +struct seq_file;
> > +
> 
> We already have a forward declaration of seq_file in fs.h.  At line
> 1583(!).
> 
> This is why forward declarations should always be placed at the start
> of the file, please.

Yes, thanks a lot, Andrew!

	Cyrill
