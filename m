Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab0LHQAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:00:32 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:35570 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab0LHQAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:00:30 -0500
Date: Wed, 8 Dec 2010 09:00:28 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>,
        Luben Tuikov <ltuikov@yahoo.com>,
        Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Message-ID: <20101208160028.GB21909@parisc-linux.org>
References: <1291823012.24312.52.camel@mulgrave.site> <Pine.LNX.4.44L0.1012081054160.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1012081054160.1885-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 10:57:46AM -0500, Alan Stern wrote:
> In the strictest sense, there's always a possibility that any change
> will crash _some_ device somewhere.  In this case I believe the
> probability is very low.  Luben's patch does not change the commands
> sent to a USB device; it only changes the kernel's interpretation of
> the data sent back.  Unless things are terribly badly broken, this 
> won't hurt.

It doesn't change the _discovery_ commands sent to the device, but (I
think ...) it will change the subsequent commands sent to the device;
eg we'll now send it SYNCHRONISE CACHE when we wouldn't have before.
I think it's low-risk too, and am in favour of seeing this patch applied.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
