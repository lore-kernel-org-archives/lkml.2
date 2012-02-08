Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab2BHUKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 15:10:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52468 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2BHUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 15:10:18 -0500
Date: Wed, 8 Feb 2012 12:10:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: pohmelfs: call for inclusion
Message-ID: <20120208201008.GA5578@kroah.com>
References: <20120208193413.GA22215@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208193413.GA22215@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 10:34:13PM +0300, Evgeniy Polyakov wrote:
> But that's enough for advertisement. Here is the code.
> I do not know whether it is a good idea to ask it for inclusion into
> mainline tree right now skipping drivers/staging part. But anyway, I
> post patch to remove drivers/staging/pohmelfs and add fs/pohmelfs
> If it is not the way to go, I will resubmit.

It would be easiest to just send a patch deleting the old
drivers/staging/pohmelfs, or just ask me to do it, which I can, and then
send a new patch just with the new code, as it is so different.

That should make it easier to review, and also small enough to fit
through the mailing list size limits :)

thanks,

greg k-h
