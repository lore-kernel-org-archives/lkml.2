Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1I1VaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 17:30:20 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35226 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1I1VaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 17:30:18 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Will Drewry <wad@chromium.org>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>,
        dm-devel@redhat.com, Elly Jones <ellyjones@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: verity target
In-Reply-To: Your message of "Tue, 27 Sep 2011 14:02:05 CDT."
             <CABqD9hYWK2czEKN87xDu7YPbRcp9xrumJ5PZ8aQTzBLafrnBMw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1316112359-6085-1-git-send-email-msb@chromium.org>
            <CABqD9hYWK2czEKN87xDu7YPbRcp9xrumJ5PZ8aQTzBLafrnBMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317245414_2944P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Sep 2011 17:30:14 -0400
Message-ID: <21505.1317245414@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4E8391E8.000B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317245414_2944P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 14:02:05 CDT, Will Drewry said:

> I was just curious if there is any interest in pulling this change, or
> if not, if there is any particular set of concerns, fixes, etc.

Out of curiosity, how much of the stack does this end up eating?  My root=

filesystem is already ext4 on an LVM partition that's on a LUKS/dm-crypt
partition on a hard drive, and I'm sure somebody out there will have used=
 xfs
instead - and then exported it via NFS or something. Are we going to get =
weird
stack overflows if people throw dm-verity into this sort of mix?

> realize it's not a small amount of code to digest (though it is
> smaller than the post from last year=5B1=5D).   Would re-posting with a=
n
> added blob explaining the name be useful,

Probably will need it to be merged, unless you set up an auto-reply that =
says
=22Patch rejected, 'verity' is *not* a typo for 'verify'=22 ;)

I'll hopefully have some more comments over the weekend if I get some spa=
re
cycles.


--==_Exmh_1317245414_2944P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOg5HmcC3lWbTT17ARAiyZAKCTnnZ0SrjxMx727zoBr0/u+rJdMQCg0Lte
zpMBlja3FzmgAxZ8M+5CD6Q=
=e2DA
-----END PGP SIGNATURE-----

--==_Exmh_1317245414_2944P--

