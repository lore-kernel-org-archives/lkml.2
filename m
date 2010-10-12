Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab0JLNWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:22:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:33266 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287Ab0JLNWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:22:53 -0400
Date: Tue, 12 Oct 2010 06:22:08 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Suchy <danny@danysek.cz>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: PATCH: ftdi_sio new VID/PIDs for various Papouch devices
Message-ID: <20101012132208.GB10556@suse.de>
References: <4CB45E2A.9020407@danysek.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB45E2A.9020407@danysek.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 03:10:02PM +0200, Daniel Suchy wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hello,
> in attached file, there's patch for FTDI USB serial converter adding new
> VID/PIDs used on various devices manufactured by Papouch
> (http://www.papouch.com). These devices have their own VID/PID, although
> they're using standard FTDI chip. In ftdi_sio.c, I also made small
> cleanup to have declarations for all Papouch devices in single section.
> 
> My patch was tested against 2.6.35.x stable kernel releases at this time.
> 
> With regards,
> Daniel Suchy
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
> 
> iEYEARECAAYFAky0XioACgkQ0m6yQqKjWoLPJACeMuWvkNTXWTOc4s8hW5Fy3U3k
> 1+YAoNwbc3pYlSB734l3aSRO+Y+w12I5
> =y+9A
> -----END PGP SIGNATURE-----

> --- drivers/usb/serial/ftdi_sio_ids.h.orig	2010-09-08 08:57:36.000000000 +0200
> +++ drivers/usb/serial/ftdi_sio_ids.h	2010-10-12 14:32:34.208586002 +0200
> @@ -1007,12 +1007,38 @@
>  /*
>   * Papouch products (http://www.papouch.com/)
>   * Submitted by Folkert van Heusden
> + * extended by Daniel Suchy (12.10.2010)

This is not needed, you get this information from the changelog
information.

Care to take this line out, and add a "Signed-off-by:" line as per the
Documentation/SubmittingPatches file?  That's required for me to be able
to accept the patch.

thanks,

greg k-h
