Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab2EOUTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:19:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39219 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169Ab2EOUTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:19:05 -0400
Date: Tue, 15 May 2012 13:19:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: mdharm-usb@one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers:Fixed C99 comment issue.
Message-ID: <20120515201901.GB23986@kroah.com>
References: <1337110335-9783-1-git-send-email-ahiliation@yahoo.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337110335-9783-1-git-send-email-ahiliation@yahoo.co.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, now I'm going to get picky, so you can get this right and I will
have no excuse to reject your patches :)

First off, your subject: is "odd". You need to specify what you did
better, with a prefix that says so.

So, for this example, it should say:
	Subject: [PATCH 1/3] USB: storage: fixed c99 comment issue

See the "USB: storage:" part?  Having a generic "drivers:" like you did
really doesn't say anything, as over half of the kernel is drivers, and
you really didn't do this for all of that codebase :)

On Wed, May 16, 2012 at 01:02:15AM +0530, Jeffrin Jose wrote:
> Fixed C99 comment issue in drivers/usb/storage/usb.c
> found using checkpatch.pl tool.
> Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>

You need an extra line before the Signed-off-by: line above.

Care to make these changes to all three of your patches and resend them?

thanks,

greg k-h
