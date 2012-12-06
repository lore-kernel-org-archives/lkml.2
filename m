Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab2LFCpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 21:45:08 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38481 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab2LFCpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 21:45:06 -0500
Date: Wed, 5 Dec 2012 18:45:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.55
Message-ID: <20121206024501.GA20682@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.55 kernel.

This only fixes a build error that some people have reported from the
3.0.54 kernel, if you don't have a problem with 3.0.54 then don't worry
about upgrading at this point in time.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                 |    2 +-
 arch/x86/kernel/ptrace.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

Greg Kroah-Hartman (1):
      Linux 3.0.55

H. Peter Anvin (1):
      x86-32: Export kernel_stack_pointer() for modules


--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQwAatAAoJEDjbvchgkmk+4loP+weZmi/kQFy5O3v9UmFjsamS
B2gHWlJ1QL1AuLk3Vw4+ZjVMQD1atFIZT7E+U0Tl+cFCRLnmJnKgACjHjdBR/vTF
RO/J7cYg0jGDM64nk7CdAday8XukJ5syUR94v0VRngazIJHbwi1SMqE+sgYxDBUC
dyDys7CujUlgUdbgmTc8ghAC0DA6OSxfCt19cKsSLgZ3PeinYHn/yOZBzMqnnL03
0KnYNkYagDFyYAckLaIvAwaUiNTAlf9zLjaCVujsOqp+yJgjUVFvhu/ZlOeLQiEH
hDQ4yY5Hm4Z/1UifFtQwC/7yb4NIsBfVRgH+gsb3JX59Gr9GciZMsemDsFwrhfGV
EBzAoLcmGFy7z4lKVFxKQ+Jp/NVzp2cKPFPltPqKWVd0DmTQqRxX+Lf6NyBXwlNL
FdVHesk6q8SC/Po1+G+y4Ti/Id5TpzKSFkvQJymjxpuMkrEvbvnVRoMQb6tpOWtt
pHv++F+bpTCjAa3elsztIbmzFhEpaWawLRI54PM4SJ0NCRw/gx7eDerfZITbaOAU
6+6Aej3LlJIEoZplTJ65lCUqdvXh4YIc8jLr21tLdcqrUQklJigh/d3PrQt5kNV7
lOBAeLwqlzCu2s+dsWrpyFrboL0acZvDHcc1YQXX5lZOyUvnXoSX5/9y+pqIaZZE
WM4y1pHyFfnrGHxFfnpl
=eelV
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
