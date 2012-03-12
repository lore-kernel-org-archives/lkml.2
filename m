Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab2CLTMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:12:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57704 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755279Ab2CLTMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:12:34 -0400
Date: Mon, 12 Mar 2012 19:12:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: simon@mungewell.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
Message-ID: <20120312191232.GB30146@opensource.wolfsonmicro.com>
References: <1331565459-1892-1-git-send-email-simon@mungewell.org>
 <alpine.LNX.2.00.1203121645050.18356@pobox.suse.cz>
 <be2be8d04b58ce75fcba9798fcb4e4fa.squirrel@mungewell.org>
 <20120312180738.GD14020@sirena.org.uk>
 <3391c87c6cc142e1b50b73eb78e70dc8.squirrel@mungewell.org>
 <20120312183235.GA28451@opensource.wolfsonmicro.com>
 <03eaca06ba2629f55144daa5a386c74b.squirrel@mungewell.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <03eaca06ba2629f55144daa5a386c74b.squirrel@mungewell.org>
X-Cookie: Someone is speaking well of you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 12, 2012 at 03:05:39PM -0400, simon@mungewell.org wrote:

> If you can point me at some (simple) implementations of the LED subsystem,
> possibly with some guidance, we can look to see if the added complexity is
> actually worth it.

I don't think any of the LED drivers are massively complex...  you just
register and then you get a callback to set the brightness.  That's
really all there is to it.

> I'd be pretty sure that other gaming controllers don't abstract their LEDs
> via this subsystem,

How sad :(

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXkoxAAoJEBus8iNuMP3dpwYP/AxHgDmK1c0Fo/JSVRFVDJXk
jkKoEFODOPcMcS3eu+FTSIZ66veuiNxxbItTAP1ih4llbXHRacLJ0teFiPXKETDf
tu48Arce/jbxNb2ot/iQxPMG3heg2+d0XA08/d2TP9S9UchXx6F2KzSA/0uSF57L
8aJD4S9Ik9y/cJKO9HvmRZzpqoSA1t3k9p7BDytXiLVDaJrL3eUomqvyhe+Fmq0G
MgH+eAKDTHsxxBUasLsEYijdALRGI5+K8J5xcKlPgk/qI0vHpkrF9bphsZeESzoZ
2WZVirOC7aP7etufreq5UqSqFgDhBdDbsVOjcaFdD5F3TdG9J23r3HZSDmRQAkv9
3e0522W3WHK+hyUyZSBbEpWiDv8TCi9VeDR0dcSpsfxed+hLFs4NwSgjIEMPp/Fg
W+4V88Fat5LaP16oaels07jeVJT42Gc5b9m7sWOleylmze6gl9Uv6174R6XAOJ4c
9Qo9wySlCAarSgooaIfRBI6GOejVMwZWRUGK3dgpgaCR7IU3O1fnxjM5M/SH8P//
BSG3siDQrB0BlDGM3I+JfXgV2zI29piyA6CV9w74Sy9QS+4useZq0RIz/c7RIhSr
PyF21GCYzNeZxfjCpAevjdbhld7lNsDUq58s75zpvNeZ7mAC9Bd/OnYWc/I4bHuJ
0uPz/ySar+a59jFTMVWO
=cNnn
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
