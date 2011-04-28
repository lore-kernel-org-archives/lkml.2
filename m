Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1D1Csi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 22:48:38 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42507 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1D1Csh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 22:48:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Hans de Goede <hdegoede@redhat.com>,
        Joerg Heckenbach <joerg@heckenbach-aw.de>,
        Dwaine Garden <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] usbvision: remove RGB format conversion
In-Reply-To: Your message of "Wed, 27 Apr 2011 22:41:32 +0200."
             <201104272241.38457.linux@rainbow-software.org>
From: Valdis.Kletnieks@vt.edu
References: <201104272241.38457.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1303958880_5598P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 27 Apr 2011 22:48:00 -0400
Message-ID: <17469.1303958880@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4DB8D57D.00A1,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1303958880_5598P
Content-Type: text/plain; charset=us-ascii

On Wed, 27 Apr 2011 22:41:32 +0200, Ondrej Zary said:
> As V4L2 spec says that drivers shouldn't do any in-kernel image format
> conversion, remove it.

Does this classify as breaking the API, and thus require a deprecation period?
Is it likely to break any userspace that wasn't planning on doing its own RGB
conversions?


--==_Exmh_1303958880_5598P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNuNVgcC3lWbTT17ARAsE1AKCwQ5ICHn0rJPk1c0r0REF6eAHAVgCg9MGk
nOFkDvSovqxMefs8zdxOje0=
=Pc66
-----END PGP SIGNATURE-----

--==_Exmh_1303958880_5598P--

