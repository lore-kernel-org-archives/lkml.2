Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0CUDGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 23:06:47 -0400
Received: from stag.seas.upenn.edu ([158.130.70.79]:49694 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0CUDGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 23:06:45 -0400
Message-ID: <4BA58D3E.1000804@seas.upenn.edu>
Date: Sat, 20 Mar 2010 23:06:38 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@enmesh.se>,
       linux-input <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: input: mt: Software finger tracking in the kernel?
References: <4BA358DB.20708@enmesh.se> <20100320194424.GC28402@core.coreip.homeip.net>
In-Reply-To: <20100320194424.GC28402@core.coreip.homeip.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

> I am not sure if input core itself is the proper place to do such
> thing, I'd envisioned something more like a library providing common
> code that drivers could opt in to use, like we hane ff-memless for
> memory-less force-feedback devices.
> 
> Does it make any sense? I guess post the skeleton of the code and we can
> discuss further.

Regardless of where the code goes, I suggest we enable tracking by default for
MT devices and perhaps have a quirt MT_NOTRACK to opt out.

If tracking is the common case and expected down stream, it would be nice to let
HID compliant devices work without needing to explicitly identify them in code.

Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkuljTwACgkQwuRiAT9o60/iBwCgudrOvmam/A0VQ2uA0UtK5R3H
l3oAnAgEV7D+FFTWjofm85Djp25QhWq1
=2+sX
-----END PGP SIGNATURE-----
