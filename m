Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1KSSut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 13:50:49 -0500
Received: from home.keithp.com ([63.227.221.253]:58405 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab1KSSus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 13:50:48 -0500
From: Keith Packard <keithp@keithp.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org
Subject: Re: max PWM is zero
In-Reply-To: <alpine.LNX.2.00.1111191124350.5248@darkstar.example.net>
References: <alpine.LNX.2.00.1111151301410.2693@darkstar.example.net> <alpine.LNX.2.00.1111191124350.5248@darkstar.example.net>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 19 Nov 2011 10:50:39 -0800
Message-ID: <864ny0kku8.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Nov 2011 11:26:07 +0000 (Local time zone must be set--see zic ma=
nual page), Marcos Paulo de Souza <marcos.mage@gmail.com> wrote:
> So, anybody gets the same message?
>=20
> I'm trying the 3.2-rc2 and it gives the same message.
>=20
> Again, if you need someone to make tests, or test some patches, I'm=20
> able to do this.

Is your machine even using the intel backlight device? You can test this
by:

# cd /sys/class/backlight/intel_backlight

Then look at 'max_brightness' and try echoing a range of numbers from 0
to max_brightness into the brightness file and see if it changes the
backlight.

It's more than possible that your machine is simply using some other
hardware to drive the backlight and that the integrated backlight
controller is simply disabled.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsf6fzYtFsjWk68qAQhIVQ/+LHiK5jMzmf1DfDMIChU42klsGSbBwlP3
eJ47W6UcnydeQxsdS+KNp0Kob039IXnA0arfYk+67DEl2hjUC08VaG86miHR5TTe
n30xLfNaA3wRzG4+3b834/0ddxsTU9aPgT4Vh5A8YAfYg3MscffvgFfQO/bsMezx
RxqfUr8z2t9W7nJaceSq1Bi3JXfA3xDxe8SsqBjQAxR/ppMsfTfqPsP43D+Mbqun
YyAlW5aS9an0zxSu9XQxwv86aQln0GLnrhi0lcmR9gaobJ+BkCUmCLNwzP5poeMv
Aph3PWa5LDbQaN5map2dXbEUZBFQi/SbUtP3W/lCwQN0fGqYrcDplWPi2mMCHWff
CFjhYDXD/SkYaEDb+4mmL3p5XdUpblZLi0lcKqpeFWn+eLtP187q35SC04rE0ksf
KkmUWixzO6ZFWhASVhb/oPqlyzP+5/xYjCdEa3DyvfGoBs5UfCjwU5xmnz0+guu+
xd9zfsa20uRYUhFxK9jgIcLKBb+GnrNpk0xQ/q8L5auiqv2j1pVcffvf/ZlW689Z
yvgVbNlPZhDqHuQrrBr6fGcg8wwAeGtYnI4bJGFFp1IKnmhQEDbJXDyfJ4ygxfxJ
B0rIoX/w/YOFA4ibt0r5s1PKPMMHrsdPRlXnfR0F+d4J7Ali5m2uk/suSDIvxNRd
qVZDbn79Ya0=
=cCjc
-----END PGP SIGNATURE-----
--=-=-=--
