Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2IQLUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:20:06 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33583 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755732Ab2IQLUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:20:04 -0400
X-Sasl-enc: aVkX/C3ocLKQa5j9p/T5aPp+5WtAyhn59L0QS0mnuQvd 1347880803
Date: Mon, 17 Sep 2012 04:20:02 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: manual merge of the usb tree with the tty tree
Message-ID: <20120917112002.GA28478@kroah.com>
References: <20120917173103.9805531382847454e2d59bb8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917173103.9805531382847454e2d59bb8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 05:31:03PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/serial/digi_acceleport.c between commit adc8d746caa6 ("tty:
> move the termios object into the tty") from the tty tree and commit
> f9dfbebb8b39 ("USB: serial: digi_acceleport.c: remove dbg() usage") from
> the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

This fix, and the other usb->tty tree issues, all look good to me,
thanks for doing them, and sorry for the problems.

greg k-h
