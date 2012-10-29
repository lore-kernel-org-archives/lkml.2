Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab2J2RXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:23:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:36273 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2J2RXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:23:41 -0400
Date: Mon, 29 Oct 2012 10:23:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, JBottomley@parallels.com
Subject: Re: WARNING: at fs/sysfs/inode.c:324
 sysfs_hash_and_remove+0xa9/0xb0()
Message-ID: <20121029172338.GA9798@kroah.com>
References: <5082D8AD.8060100@nod.at>
 <CAFLxGvxB0yH2qjOv9DfrAj9+ScCbHaY_gCCJ4HWadJHWKa4pLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvxB0yH2qjOv9DfrAj9+ScCbHaY_gCCJ4HWadJHWKa4pLw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 06:08:22PM +0100, richard -rw- weinberger wrote:
> On Sat, Oct 20, 2012 at 7:00 PM, Richard Weinberger <richard@nod.at> wrote:
> > Hi!
> >
> > I can reliably trigger the following warning by physically detaching my disk
> > array after
> > stopping md1.

Does this show up in 3.7-rc3?

Looks like a md issue, not a sysfs one, so not much I can do about it,
sorry.

greg k-h
