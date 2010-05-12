Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab0ELTuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:50:21 -0400
Received: from kroah.org ([198.145.64.141]:33051 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab0ELTuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:50:14 -0400
Date: Wed, 12 May 2010 12:49:34 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Jean-Fran=E7ois?= Moine <moinejf@free.fr>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Daniel Mack <daniel@caiaq.de>
Subject: Re: linux-next: manual merge of the usb tree with the v4l-dvb tree
Message-ID: <20100512194934.GC31534@kroah.com>
References: <20100512155750.c6633e4c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512155750.c6633e4c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 03:57:50PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/media/video/gspca/gspca.c between commit
> 659a02869f4a8be95df9efa76af02e53e400555f ("V4L/DVB: gspca - main: Convert
> wMaxPacketSize from little endian 16 to cpu") from the v4l-dvb tree and
> commit 42b4658241d4c16c838daf9d63c0029cd7269fe0 ("USB: rename
> usb_buffer_alloc() and usb_buffer_free() users") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

The fix looks great to me, thanks.

greg k-h
