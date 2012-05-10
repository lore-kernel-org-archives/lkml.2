Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab2EJRbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:31:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44052 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764Ab2EJRbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:31:07 -0400
X-Sasl-enc: iqzBhO+TkRJHm7OslZeZytXAhHIlinzDhTuMIUduHW+X 1336671066
Date: Thu, 10 May 2012 10:31:05 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: linux-next: manual merge of the scsi-post-merge tree with the
 driver-core tree
Message-ID: <20120510173105.GA2531@kroah.com>
References: <20120510185746.1b7b8e582c0c968633b6e2f1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510185746.1b7b8e582c0c968633b6e2f1@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 06:57:46PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> mm/page_alloc.c between commit 155cbfc802e4 ("mm: use KERN_CONT in printk()
> continuation lines") from the driver-core tree and commit "mm: print
> physical addresses consistently with other parts of kernel" from the akpm
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Looks good to me, thanks.

greg k-h
