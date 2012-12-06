Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab2LFCq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 21:46:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2LFCqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 21:46:25 -0500
Date: Wed, 5 Dec 2012 18:46:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.22
Message-ID: <20121206024622.GA26629@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.4.22 kernel.

This release contains a single fix for a build error that some people
have reported with the 3.4.21 kernel, if you don't have a problem with
3.4.21 then don't worry about upgrading at this point in time.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                 |    2 +-
 arch/x86/kernel/ptrace.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

Greg Kroah-Hartman (1):
      Linux 3.4.22

H. Peter Anvin (1):
      x86-32: Export kernel_stack_pointer() for modules


--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQwAb+AAoJEDjbvchgkmk+DQ4QAIscqQ3sswVPZY/LJ9OD4AlK
oWqqUEYQl897EHYGAw1s1Fu5uSCdvp/uBtsy19T4UW3bmwqzsi0ULWVfJsjwBaxZ
zmCRSBATdhBEFV3ibwcn7du62jggSHOnCOv350rE+Q7oleng24YVLoNq3NwsHL4U
ovLHh2EXvp9bc32/yVf7e/OD3DDNqGAAyAz7sI1Inj6Bmtz29NHo7c8m8g6c7NDd
IVszaBNzNoYR3nXJxwYxWGTR2WFoncnIwXiW0DWviFfI2wpzq38lh6m5aRXdsgD7
RMTM7yysszW021zbFOn5EWUIw1ebW4LnRE1PB9c/EObRgihZxkhr2YW3DfcTqcfG
96oqRSgrYW6aDZIdiHVs0ynSa9qarq9x7tSm5DFxHRpPpzKQ3mHnm/4NwHG/7+1G
ihwuTUWKPzLE+MGHOQVa3keZULywFklpzyaUU8xhKyYVUbscOqtw9HANT8BL88wk
kTi1O7BFjdKKCp2jW1vxDIxF9v0jKir4p9/IqWEFSBdNOrqX2AWLw/db+jN+YzyM
wP4tzPCsDMNHgZYxBMgPdfFDEmc8iPk7ikVfKUtg8s+VVqOEd/kHTye7ocWMgiSK
KJg7WZgBzKqmKlatF68ow0rLvk8boEb11tQGy0MJHMaPEDc6YUeH+5Td/iYL4r3W
DWiZATyecwurtafC3vgW
=BvAj
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
