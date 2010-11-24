Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0KXOsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:48:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38444 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab0KXOsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:48:20 -0500
Date: Wed, 24 Nov 2010 09:48:11 -0500
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: ltuikov@yahoo.com, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Message-ID: <20101124144811.GA29196@infradead.org>
References: <549123.75632.qm@web31809.mail.mud.yahoo.com>
 <1290593429.14652.33.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290593429.14652.33.camel@mulgrave.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 10:10:29AM +0000, James Bottomley wrote:
> The final question is is it worth it?  Since USB devices are supposed to
> be hot unpluggable, surely a USB device with a write back cache would be
> a disaster: no-one will SYNC the cache on a surprise unplug anyway ...
> therefore there shouldn't really be any of them surviving in the wild
> (famous last words, I suppose).

There's tons of USB devices with writeback caches.  Recent windows
version tend to use the FUA bit a lot because of this.  And the linux
usb storage target implementation thus has a hook to ignore the FUA bit,
and it's probably not the only one..

