Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460Ab2JKVxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:53:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45320 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759432Ab2JKVxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:53:19 -0400
Date: Fri, 12 Oct 2012 06:53:10 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Stuge <peter@stuge.se>
Subject: Re: REGRESSION: usbdevfs:
 Use-scatter-gather-lists-for-large-bulk-transfers
Message-ID: <20121011215310.GA24651@kroah.com>
References: <20121010203118.GA792@polaris.bitmath.org>
 <5076819C.9010504@redhat.com>
 <20121011213707.GA2187@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011213707.GA2187@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 11:37:07PM +0200, Henrik Rydberg wrote:
> Hi Hans,
> 
> > Oh what fun (not). The best way to figure out what really is going
> > on is to get some usb level traces. Note my first hunch is that what
> > you're seeing is a device firmware bug, as this patch together with
> > a new libusb (which you seem to also have) will make bulk transfers
> > run slightly faster, which might be just enough to overwhelm your
> > device ...
> 
> Or, the large bulk transfer actually never worked in the first place.
> The list you gave me seemed boringly long, so I read the patch more
> closely instead. The fix below is the result. Greg, will you please
> take it through your tree?

Henrik, Very nice fix, thanks for debugging this.

Hans, any objection to me taking this?

greg k-h
