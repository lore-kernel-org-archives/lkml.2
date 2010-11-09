Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0KICfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:35:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52819 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab0KICfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:35:24 -0500
Date: Tue, 9 Nov 2010 13:35:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: <linuxppc-dev@ozlabs.org>, jbaron@redhat.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, "David S. Miller" <davem@davemloft.net>,
        Anton Blanchard <anton@samba.org>,
        Kumar Gala <kumar.gala@freescale.com>
Subject: Re: [PATCH] powerpc: Add jump label support
Message-Id: <20101109133517.b6be28bf.sfr@canb.auug.org.au>
In-Reply-To: <45fbc3cd7f6ce404d1e25bf01695fb629d86189d.1289189560.git.michael@ellerman.id.au>
References: <45fbc3cd7f6ce404d1e25bf01695fb629d86189d.1289189560.git.michael@ellerman.id.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Nov_2010_13_35_17_+1100_+FnMtx325yVKvf=M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Nov_2010_13_35_17_+1100_+FnMtx325yVKvf=M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Just a trivial note ...

On Mon,  8 Nov 2010 15:12:46 +1100 (EST) Michael Ellerman <michael@ellerman=
.id.au> wrote:
>
> diff --git a/arch/powerpc/include/asm/jump_label.h b/arch/powerpc/include=
/asm/jump_label.h
> new file mode 100644
> index 0000000..feffb86
> --- /dev/null
> +++ b/arch/powerpc/include/asm/jump_label.h
> @@ -0,0 +1,46 @@
> +#ifndef _ASM_POWERPC_JUMP_LABEL_H
> +#define _ASM_POWERPC_JUMP_LABEL_H
> +
> +/*
> + * Copyright 2010 Michael Ellerman, IBM Corp.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#ifdef __KERNEL__

You don't need this protection in a file that is not exported to user
space.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Nov_2010_13_35_17_+1100_+FnMtx325yVKvf=M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM2LNlAAoJEDMEi1NhKgbsC+0H/2ihZ22fwibF/Dc6lxK04fY0
MG7bDLmDth0I4FFHoNucxoIULV/XQGgQ/z0+TCO3fbpHgg8SnqHSpOhedF4OjWtm
JTKKvV2uF4KLIYsRVzkx+0bUByB0LcOEox2hmmCFVySxxsNkxDz4Z7vP/ziJgy9Y
teuO3IeivTl/UGNMK5RigjzrEzfHwFThcy845ZUfG7fqVfF0F58TAuqDJ2HSFiqo
hdh/VS9/VPCSKPJfV8xjAdgxkpmX3Z1EWWoeAUqKPbxcYATLrZlbIPQdcRbXBPYI
QrzYv7S03tsKeokRQN+ogYto0Y4JODK00NjbgBLo1o6YmAVeS8MygQyxddVkFS4=
=2Erw
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Nov_2010_13_35_17_+1100_+FnMtx325yVKvf=M--
