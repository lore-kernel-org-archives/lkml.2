Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1K1Ct1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 21:49:27 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:46172 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab1K1CtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 21:49:25 -0500
Date: Mon, 28 Nov 2011 13:49:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the drm tree
Message-Id: <20111128134917.ba94950dcf6f6aa03ebd4ffe@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Nov_2011_13_49_17_+1100_G7NQ3Y6b44q.8jQh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Nov_2011_13_49_17_+1100_G7NQ3Y6b44q.8jQh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/gpu/drm/gma500/psb_drv.c: At top level:
drivers/gpu/drm/gma500/psb_drv.c:1162:2: warning: braces around scalar init=
ializer [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1162:2: warning: (near initialization for =
'driver.fops') [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1163:4: error: field name not in record or=
 union initializer
drivers/gpu/drm/gma500/psb_drv.c:1163:4: error: (near initialization for 'd=
river.fops')
drivers/gpu/drm/gma500/psb_drv.c:1163:4: warning: initialization from incom=
patible pointer type [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1163:4: warning: (near initialization for =
'driver.fops') [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1164:4: error: field name not in record or=
 union initializer
drivers/gpu/drm/gma500/psb_drv.c:1164:4: error: (near initialization for 'd=
river.fops')
drivers/gpu/drm/gma500/psb_drv.c:1164:4: warning: excess elements in scalar=
 initializer [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1164:4: warning: (near initialization for =
'driver.fops') [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1165:4: error: field name not in record or=
 union initializer
drivers/gpu/drm/gma500/psb_drv.c:1165:4: error: (near initialization for 'd=
river.fops')
drivers/gpu/drm/gma500/psb_drv.c:1165:4: warning: excess elements in scalar=
 initializer [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1165:4: warning: (near initialization for =
'driver.fops') [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1166:4: error: field name not in record or=
 union initializer
drivers/gpu/drm/gma500/psb_drv.c:1166:4: error: (near initialization for 'd=
river.fops')
drivers/gpu/drm/gma500/psb_drv.c:1166:4: warning: excess elements in scalar=
 initializer [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1166:4: warning: (near initialization for =
'driver.fops') [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1167:4: error: field name not in record or=
 union initializer
drivers/gpu/drm/gma500/psb_drv.c:1167:4: error: (near initialization for 'd=
river.fops')
drivers/gpu/drm/gma500/psb_drv.c:1167:4: warning: excess elements in scalar=
 initializer [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1167:4: warning: (near initialization for =
'driver.fops') [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1168:4: error: field name not in record or=
 union initializer
drivers/gpu/drm/gma500/psb_drv.c:1168:4: error: (near initialization for 'd=
river.fops')
drivers/gpu/drm/gma500/psb_drv.c:1168:4: warning: excess elements in scalar=
 initializer [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1168:4: warning: (near initialization for =
'driver.fops') [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1169:4: error: field name not in record or=
 union initializer
drivers/gpu/drm/gma500/psb_drv.c:1169:4: error: (near initialization for 'd=
river.fops')
drivers/gpu/drm/gma500/psb_drv.c:1169:4: warning: excess elements in scalar=
 initializer [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1169:4: warning: (near initialization for =
'driver.fops') [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1170:4: error: field name not in record or=
 union initializer
drivers/gpu/drm/gma500/psb_drv.c:1170:4: error: (near initialization for 'd=
river.fops')
drivers/gpu/drm/gma500/psb_drv.c:1170:4: warning: excess elements in scalar=
 initializer [enabled by default]
drivers/gpu/drm/gma500/psb_drv.c:1170:4: warning: (near initialization for =
'driver.fops') [enabled by default]

Caused by commit 5c49fd3aa0ab ("gma500: Add the core DRM files and
headers") interacting with commit e08e96de986c ("drm: Make the per-driver
file_operations struct const").  Again needed fixing up in commit
b63e0f9cb433 ("Merge branch 'drm-gma500-alanc' into drm-core-next").  Or
Alan should do his work based on the drm-next tree (which would then have
to become non rebasing) ...

I have used the version of the drm tree from next-20111115 again.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Nov_2011_13_49_17_+1100_G7NQ3Y6b44q.8jQh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO0vatAAoJEECxmPOUX5FEzyUQAJmFRNpbTaeWZb36+wishP3z
6Zi8l+HsfLgJuftLfFABnRivJLHTtSOnIipipGmWuwmKm+OgoISLS8QpoM3K5Obh
J/ELmEf13JhmiWh+0s+hTVyrdFXkkAq0m8L3Swpr9FrjJt0Atc57ThoFE6/80pzA
QHp8yd1Y8v8FcwwkTvv2gUBevtbvQxSGvNbD+iUdEMJUJcT1M7oz3kWrj/OkhNuS
y9ox0ZaCmjoEL6wCfUbGZeGeX9tniOKtpUUS3b8Gd5yCgoUrPDHOYwy3oIK34D61
kNbM1AndXMOrk/hiORYmpODtsH+n53CWRu4A3Tlxi+FPLIMuYVhix/ziy2uFp3+Q
dOqF+JKBBDJXwAtpp98tu2nVzGqKXw4xsEAHKzSXnaGlSEeSOasB8iqwgsam+hey
cGK01IkO/UI5HxrxdRC5EZeWlz5Ye97oDlkvH8UoNIvkO4g1rlAmBeHRdFKlNdJj
s6wUb60XUboLoKEsgfhoYfzdbJ8V4r/gYRGGSn2CLvUpM8CdWU0J1M7UColL0l6P
mKVEjkAdtnQCcKbF+aS3YGUg/vEgA3OGHIQlvYmGcreVRHiRzGbdApMUoUQmH0tC
OxMAMEYT7spYcx6ThMVBAfltMdvkWUC5kQgoddP8TeHBM35RiQDOoUe+U6hOTSxp
whRt8ixxm5qVL/QCnPe/
=wljf
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Nov_2011_13_49_17_+1100_G7NQ3Y6b44q.8jQh--
