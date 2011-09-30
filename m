Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1I3VBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 17:01:54 -0400
Received: from home.keithp.com ([63.227.221.253]:36828 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab1I3VBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 17:01:53 -0400
From: Keith Packard <keithp@keithp.com>
To: Zan Lynx <zlynx@acm.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Samsung Series 9 seems to require acpi=nonvs to resume properly
In-Reply-To: <1317414897.2629.5.camel@knife>
References: <1317329529.3151.10.camel@knife> <1317413360.2629.2.camel@knife> <201109302222.22528.rjw@sisk.pl> <1317414897.2629.5.camel@knife>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 14:01:49 -0700
Message-ID: <yuny5x568xu.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 14:34:46 -0600, Zan Lynx <zlynx@acm.org> wrote:

> It is the Intel i915 driver. It is an Intel i5-2537M system with the
> integrated video on the CPU.

You might compare the output of intel_reg_dumper in the
working/not-working case before the i915 driver loads.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhi4+Qp8BWwlsTdMRAgLaAJ958weTjNFMwY0fxqz4XlYJOYsJSQCfT7Hj
x7+7xNn+fzZ1jNM2lNsawEU=
=xQXt
-----END PGP SIGNATURE-----
--=-=-=--
