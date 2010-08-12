Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025Ab0HLMvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:51:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53744 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0HLMvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:51:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CznToQuu0KBcgqZNB3Td/f3nhQOk7M59fS1kKsmZEaYwJBdo9huBCEpoiUBmLZ7GuV
         w2gLgX+ers9lajZnBtm6ok3MmyoYhYKqz6aFygYUIJVyhp14tlA3IaabzPF4sWwrw8Su
         dJFEM7LxcXGD/oCZAqaDamYEpJJT1XiWo38LY=
Date: Thu, 12 Aug 2010 15:55:51 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: BUG: using smp_processor_id() in preemptible [00000000] code
Message-ID: <20100812125551.GC12274@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Oops, I'm sorry for the typo in my first mail - m/though/thought/g.


	Sergey

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxj71cACgkQfKHnntdSXjSjwgQAlqLVetSoSCFwck0vBHzo4DYC
rE+kDnnEFI2RWY8AplO1UE5oYOHjZ5FEK+72gUQ70AGq0pJgHLWNyGDooh0f5fT+
EFKIoFpqMzAkFHG09rLtbQQ/ndubS0nunDUvFOzqe3dhfXGIV+KSBMrc6t2YCb0z
cG9wWq5M6A/vyzB1+GA=
=ePkr
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--
