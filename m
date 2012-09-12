Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab2ILOE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:04:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53168 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab2ILOEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:04:54 -0400
Date: Wed, 12 Sep 2012 07:04:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: devel@driverdev.osuosl.org, Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging/vme: Use pr_ printks in vme_user.c
Message-ID: <20120912140448.GA3531@kroah.com>
References: <20120904202053.GA23449@kroah.com>
 <1347347775-9282-1-git-send-email-yamanetoshi@gmail.com>
 <20120911190829.GA3327@kroah.com>
 <CAOTypNRQn+yTH8jkDf2u+DAV42HM-igrxS4JO2NLu2U2PgS_7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOTypNRQn+yTH8jkDf2u+DAV42HM-igrxS4JO2NLu2U2PgS_7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 04:36:19PM +0900, Toshiaki Yamane wrote:
> On Wed, Sep 12, 2012 at 4:08 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Sep 11, 2012 at 04:16:14PM +0900, Toshiaki Yamane wrote:
> >> The below checkpatch warnings was fixed,
> >>
> >> -WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
> >> -WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...
> >> -WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
> >
> > A lot of these can be using dev_* instead of the pr_* functions, right?
> > Please convert to using them wherever possible.
> >
> > Because of that, I can't take this patch, sorry.  Care to redo it?
> 
> Yes. Is this collect?

"correct"?

> I must use dev_* procedure when the following conditions are met:
> - If I have access to struct device object by the argument of the procedure
> - Except for the right: struct net_device, etc.
> 
> Otherwise, I must use pr_* procedure.

Yes, that is correct :)

greg k-h
