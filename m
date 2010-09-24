Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0IXDmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 23:42:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43193 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab0IXDmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 23:42:08 -0400
Date: Fri, 24 Sep 2010 13:42:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Kacur <jkacur@redhat.com>, Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the bkl-llseek tree with the sound tree
Message-Id: <20100924134201.e6385b98.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Sep_2010_13_42_01_+1000_wbzUg34DnVoI8EI7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Sep_2010_13_42_01_+1000_wbzUg34DnVoI8EI7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the bkl-llseek tree got a conflict in
sound/oss/sh_dac_audio.c between commit
095a0f6df246bdc57b57d616c4698e41fbd3bf43 ("SOUND-OSS: Remove
sh_dac_audio") from the sound tree and commit
5295184fb318693b4ef2cd8056bf1a7cb43586d7 ("llseek: automatically
add .llseek fop") from the bkl-llseek tree.

The former just removes the file updated by the latter.  I just removed
the file.

Arnd, (assuming that you will do a rebase anyway) you may as well just
drop the hunk that affects this file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Sep_2010_13_42_01_+1000_wbzUg34DnVoI8EI7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMnB4JAAoJEDMEi1NhKgbsocIH/RhSx7yV12CPb2B+b6UrV+3d
4GuM8ayygOf1Szs2dD3xCk3bMlHzZXjqtoQ4yGPyeaK4JS69MBk03stO1F7zeVoD
Hxj/Ni0mR5I/XXyzNkRr8jBJxQobh6fpjQNiFadKhwzARZXyziZvPBt+xNlBRUxy
99HXdMeAqkzwJoWuE+M33yC4mOWOEHvN1uGtoZALOEVmM70+WpXo8G+F9o4M3tiD
XhNjBm5YEhVI3huGXEiLg4TMpzn5bsaloF2JfZsFd4hfWsYUFKrViES/pJUfrjuE
Xn5KsoOmh+lVfx/RLm5ZXtAVTqr0Ba61mzVJtQy7i6KiS+JMNWAlBevkKycawmk=
=fQYn
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Sep_2010_13_42_01_+1000_wbzUg34DnVoI8EI7--
