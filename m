Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab2AZHhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 02:37:37 -0500
Received: from home.keithp.com ([63.227.221.253]:57536 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab2AZHhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 02:37:36 -0500
From: Keith Packard <keithp@keithp.com>
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915 wakes from suspend to RAM with blank screen after commit cd9dde44f47501394b9f0715b6a36a92aa74c0d0
In-Reply-To: <20120123063313.GA2113@nbgentoo>
References: <jfe47e$5dn$1@dough.gmane.org> <86mx9gkjlv.fsf@sumi.keithp.com> <20120121184453.GA2698@nbgentoo> <86hazokcb7.fsf@sumi.keithp.com> <20120122102912.GA2123@nbgentoo> <867h0j83vx.fsf@sumi.keithp.com> <20120123063313.GA2113@nbgentoo>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 25 Jan 2012 23:37:28 -0800
Message-ID: <86vcnyc3t3.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jan 2012 07:33:14 +0100, Lubos Kolouch <lubos.kolouch@gmail.com>=
 wrote:

> dmesg after boot - http://paste.pocoo.org/show/539115/
> dmesg after OK resume - http://paste.pocoo.org/show/539117/

I've posted a couple of more comprehensive patches that you should have
received; I'd like to know if you can test them to see if they resolve
the issue as well.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTyECuTYtFsjWk68qAQhV3xAAwKE32mZvJHgfk+qB4u93N+R4tku/Z5gv
O4y3+vy7DWIQJC6czaMeYdX9soIkyd1R/H7PnkStH9BLLVB+7zXWjbbENsX94/ec
jerLaczmPqAM1o5bTUc9Js1+y6edCXt7ypSiG7iTldJEPpWHLHwy+cc/IeiC89wr
WWQhY1VFDnX4aVKfO6px/nd42/7Tc3hUSP+rkGUGaniLaa1GGOnF0CDKrbDgxbSo
StuHvqbzMUBvFUonkQ2TrrLpVjnUBaSCOp9dBo0xvzgWKOXiC/OqKR8/sckxC2RQ
deaWeYAa2CDwHeSqaf22nL437IUugpJs+VdCOySv6JEhPLL5KmbVbK0T2OC206jG
nRZ45pWHvg8asVedLcgUiPhBp5ikIumn5kZ0gCMp1YwgrzFkc4sWujj1HwE9yxU1
ETGIvf3T+PSwnfMcrE5LfLsheFkHDYZ37PKFVaU9ymIWGjzpypzNwrD3h+d0TJJJ
Tw2rageDVPrZ2wfPOFgJQ9Wmu45pOB7CStaOzhFZSwDCbO216P/9ux6oFOayv183
oDhuLg6KOMI2XnM2N3xKh84WxVohO9v5SvlDCDZzZ1ugDj2lE0UlW+zXeMExwCxZ
4yI1J0VksagUdKxuJ2j16PK7fxojdg7Ij/ecGjjazmuJt6O3C7nMXR2DuTWu3iAI
JGTLXG6n0IU=
=h+dS
-----END PGP SIGNATURE-----
--=-=-=--
