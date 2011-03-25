Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1CYRDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:03:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50897 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754261Ab1CYRDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:03:12 -0400
Date: Fri, 25 Mar 2011 13:03:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Chris Wright <chrisw@sous-sol.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3] usb: core: Change usb_create_sysfs_intf_files()' return
 type to void
In-Reply-To: <531a6364dd1220278e76479423ce697e32bf4082.1301003830.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1103251302410.2047-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011, Michal Nazarewicz wrote:

> The usb_create_sysfs_intf_files() function always returned zero even
> if it failed to create sysfs fails.  Since this is a desired behaviour
> there is no need to return return code at all.  This commit changes
> function's return type (form int) to void.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/usb/core/sysfs.c |   13 +++++--------
>  drivers/usb/core/usb.c   |    3 +--
>  drivers/usb/core/usb.h   |    2 +-
>  3 files changed, 7 insertions(+), 11 deletions(-)
> 
> On Fri, 25 Mar 2011 16:33:12 +0100, Alan Stern <stern@rowland.harvard.edu> wrote:
> > My style preference is to put the empty statement before the comment.
> > It's unusual to have a comment appearing before a statement on the same
> > line.  For example:
> >		;	/* We don't care if the function fails */
> 
> Changed.  And I agree, it looks better now. :)

Acked-by: Alan Stern <stern@rowland.harvard.edu>

