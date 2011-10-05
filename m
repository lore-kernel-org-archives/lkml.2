Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935305Ab1JEUQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:16:28 -0400
Received: from home.keithp.com ([63.227.221.253]:35409 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934686Ab1JEUQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:16:27 -0400
From: Keith Packard <keithp@keithp.com>
To: Alex Davis <alex14641@yahoo.com>,
        "terraluna977\@gmail.com" <terraluna977@gmail.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re:  Regression: i915 blank issue on kernel 3.1.0-rc3
In-Reply-To: <1317844780.69103.YahooMailNeo@web130122.mail.mud.yahoo.com>
References: <1316957834.67111.YahooMailNeo@web130112.mail.mud.yahoo.com> <1317676210.22894.YahooMailNeo@web130106.mail.mud.yahoo.com> <yun1uuslfhg.fsf@aiko.keithp.com> <1317844780.69103.YahooMailNeo@web130122.mail.mud.yahoo.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 05 Oct 2011 13:16:23 -0700
Message-ID: <yun4nznmbxk.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 5 Oct 2011 12:59:40 -0700 (PDT), Alex Davis <alex14641@yahoo.com> w=
rote:

> By 'disable', do you mean revert? If so, I would the like chance to submi=
t a patch that adds a boot parameter=20
> for the driver to disable the backlight by default, e.g: i915_disable_bl.=
 Once the issues are sorted, the
> parameter could be removed.

If your machine used to work (with 3.0) and does not work with 3.1-rc,
then we need to fix the driver so that, with no configuration changes,
your machine continues to work. Preventing regressions is our primary
responsibility when changing the drivers.

Does reverting Matthew's backlight patch fix a regression on your machine?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBToy7FzYtFsjWk68qAQjQ9hAAkJDGR5ZAQqWFDdpuYApxuaKfr+5v88eh
BY6NlEY3pwHI9moWZORFqNKs0IOazQUgke1veqdBDmk8tZTdq8z7uHyys41gZbo2
m55zQ9J9rtZs17nHeS59Es/fuM7p3VSqUhQhqucbIY3SvtLXPgzKDwWb4TIQjglg
IEQSHFn2bdpyGmcvi/6FFzcz+gbiUBDkdildVt3r4oyZ26NAeKTzSbn1gtn62I+V
+LTCatBuNBYrDQrtEulWFeGXVL1CVMnTzZmaUsXGNu2FahrII3VnDz+4RVRxA8Di
TSdZLznNe4zD8OYXLsN6PE38JtFPmgFpPJGYN06JTLbd4E5QVpKszoGfK8OvdHKv
KRCEGMRPKLGmOhvflWxkGvNtOrAfjnhLyUMC3KQmCOTJ4fuRNsmLum6EcmN5oUBR
5qf07YZWgLqLv5Lr3HDCbWmSoQ+l5sQSArm0bJUmc0BBZdEP4jCzgbO1HNSsTboJ
y98FyysLNozU/5VU/WAZzLd7hhyzoZAZzDmezO8jPip3S/AWdN+z2VpGnHIT4y6B
d9jBphM3wAtnmyV5vrDJD9Ago4zAQ4uwJOVo+Yt6kBOaC0qqEy0uwZVcrC9uucMv
cAWOcuGUetLL47GW3uITwZOeKgzZ3EUeQrj5iSYF/L2BMy1UZs+L+EYI8VZC6rtM
LwnElkco/DI=
=RFcd
-----END PGP SIGNATURE-----
--=-=-=--
