Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab1JEHVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:21:00 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:48616 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab1JEHU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:20:58 -0400
Date: Wed, 5 Oct 2011 18:20:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the moduleh tree
Message-Id: <20111005182050.d9576590f52d84aa952c235a@canb.auug.org.au>
In-Reply-To: <20111005040005.GB14123@windriver.com>
References: <20111004175703.0e319ee270c9dcd1ff253164@canb.auug.org.au>
	<20111005040005.GB14123@windriver.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Oct_2011_18_20_50_+1100_tdx4nSUA_7jjFH66"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Oct_2011_18_20_50_+1100_tdx4nSUA_7jjFH66
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Wed, 5 Oct 2011 00:00:06 -0400 Paul Gortmaker <paul.gortmaker@windriver.=
com> wrote:
>
>  staging-Add-export.h-to-rts5139-rts51x_scsi.c.patch
>  pinctrl-EXPORT_SYMBOL-needs-export.h.patch
> +staging-Add-export.h-for-EXPORT_SYMBOL-to-drivers-st.patch
> +ath6kl-THIS_MODULES-needs-export.h.patch
> +ath6kl-module_param-needs-the-inclusion-of-modulepar.patch
> +staging-iio-adc-add-includes-of-module.h-and-stat.h.patch
> +staging-r8712u-include-module.h-where-needed.patch

You should be able to drop these last 2 as well (Greg has picked them up).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__5_Oct_2011_18_20_50_+1100_tdx4nSUA_7jjFH66
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjAVSAAoJEECxmPOUX5FEpTsP/04y8a+zzA6yGeW54dSCSzzf
L1nAUG08fnnRQ+bhB1UHR8f74pYWPQlWjejtXk0Jnse+Yt3KpLCukqRKtI/pom9L
6zy96pbcYyLhVSJJEMmckHSbbyHkmgEzFRLHCD8FkvcOZ5is3fZeNjvaZJpY+p7Y
1WfYjQUHCGsgSPiOMaU0XU9l4EtiLmCVyPRmFrvzzp3E27sEIg7cqNL8fdJFckjR
g0IBgoVxIQ0tul+i5HTGRvcQJGTPXMAC7nFLCs2k64VJO10Ci7beWGLEn6XNg6sZ
8eff9jVl9CMjX/eASdLktHUasSMh/jV+CqV6zBl+kkE7U0mRqBWTDWtTRkKAk61k
qrEUMOnKF8IN615yqODZOa93z4pSD3cGDvc6emD4sjzuVjfd65OS2xZcCQZ/G9d9
VuwEqE48jLZ0vLn0POigLxY9Up8f05sebzDp1za7sZ/Jw7xXGw5NgLxiNbkSM4Ow
nRNlkVzSHQ8VT2ZxT+JLHL2oY9AOtOq0pFUEBRf/zMyhNEcxwX0DJX47eeWrb+Au
mvS5SlfdZD1PNpMaua3q5gMyAhD7gF74+VdvKIPUyIYzyyKa880RuheTVohJWLpA
dEvb3DjipY+qLujzrGyEw11SFhZEeFIEuGU1G18/9WwZmQEOMOow2dTawQwdb5LK
Bo9mEke/hl9YvrVf94tS
=6Yey
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Oct_2011_18_20_50_+1100_tdx4nSUA_7jjFH66--
