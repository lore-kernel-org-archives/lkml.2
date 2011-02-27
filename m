Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab1B0Wev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 17:34:51 -0500
Received: from leo.clearchain.com ([199.73.29.74]:19971 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1B0Wes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 17:34:48 -0500
X-Greylist: delayed 1006 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Feb 2011 17:34:47 EST
Date: Mon, 28 Feb 2011 08:17:54 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: Henrik Rydberg <rydberg@euromail.se>, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, chatty@enac.fr, trivial@kernel.org
Subject: Re: [PATCH 1/2] HID: ntrig don't dereference unclaimed hidinput
Message-ID: <20110227221754.GB21883@barra.bne.redhat.com>
References: <1298610932-21957-1-git-send-email-rafi@seas.upenn.edu>
 <20110226073633.GA1753@polaris.bitmath.org>
 <4D68B0AE.2090000@seas.upenn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D68B0AE.2090000@seas.upenn.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Mon, 28 Feb 2011 08:48:00 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 02:50:06AM -0500, Rafi Rubin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 02/26/11 02:36, Henrik Rydberg wrote:
> > Hi Rafi,
> > 
> > On Fri, Feb 25, 2011 at 12:15:31AM -0500, Rafi Rubin wrote:
> >> Moved the claimed input check before dereferencing field->hidinput to
> >> fix a reported invalid deference bug.
> > 
> > How long has this problem been seen? If it is recent, it should
> > perhaps be fixed in the hid core instead. If it turns out to be an old
> > problem, please add stable to the Cc.
> 
> I have no idea.  Peter discovered it with a preproduction unit.  He sent me a
> proposed fix which seemed quite sensible.  I have not seen the bug in action nor
> records of the traffic.

Ben tried to get some nouveau fixes in for a new box that box crashed on
bootup. v2.6.38-rc5-115-g6f576d5 is the version I tried but I can't say when
it started.

either way, given that the same fix is in at least one more driver it would
make sense fixing this ealier in the stack.

Cheers,
  Peter

> >> Switched to a goto instead of an extra indent for most of the function.
> > 
> > If you put these janitory changes into a separate patch, it will be
> > much easier to apply the bugfix to stable versions.
> > 
> > Thanks,
> > Henrik
> 
> It might be a few days, but I'll split that into two patches when I get a chance.
> 
> Rafi
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQIcBAEBAgAGBQJNaLCrAAoJEPILXytRLnK2pQsP/3OgaO2YILN9YYuZZxJ+JVa0
> cgiFAZxV7BbznMo0sg05RbsF0r1H3rEAzf2JN1NadndC720E6DhDthjvkSZqkdkv
> v2gV+NHLyW9qaCsvgGMf7yy72880sA9fL0dzUde+W6rdgH7jgNiAp8ceiDpNIWQH
> yj1rOemNuJbXwaC9EiBb0kswxwrshA4nwaDtWxb1/e61nwRrletkrfOX6EX8uNdW
> 6ogywsVARb1w5A3xZstF2SKPBz9Su/kSlGMgE/j2LizwVoFEZY7Or6JUwpBnHchr
> w7a9eKJ4GjW8phU6YQppkNS61tMO4FuToGEYkcDLKbJaGogWO+QeqNA9bqcSjPA/
> 0F4Zf5CExQjnjmLK4yl0HUPzBtvmJQ/HjpMw6gPFwkqv0QwHUex8QA0Vw3t2LR24
> oliI6r6qnuGjHxJidpAdXnhaZn7rB5TCxmHejoAW9MYHKp52xY9IM4ys9lIRSDH+
> CbNN6sNL4/VLZrd5hBSnkZxXvPjUq3OQ/uzRPbrXPj0lz7hCt3YLZB1Me1N862uL
> 81e4T6AqD79dMh/TcwT93PNFD3Sv2mAhgNYBo3j9lz2HjeQR3EvhLXOfHxFwoDgh
> k7QYeyKNzYRrTh96EA3zcBIR6yVk3Mq7ASAI/km35nqoEL/iFBAxELS0yKDuuR5z
> rtGDDwfYxJDxwsVV93Hx
> =AygA
> -----END PGP SIGNATURE-----
