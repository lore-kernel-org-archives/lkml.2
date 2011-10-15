Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1JORsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 13:48:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47339 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab1JORsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 13:48:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Johannes Stezenbach <js@sig21.net>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: Your message of "Sat, 15 Oct 2011 13:45:27 +0200."
             <CA+O4pCKbJCtF53jUBvQMX+zgPZ=YxCwGHyP-8JMx=++d5sCiCA@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20111014192153.GA18439@sig21.net> <Pine.LNX.4.44L0.1110141613420.2036-100000@iolanthe.rowland.org> <20111014224549.GA22810@sig21.net>
            <CA+O4pCKbJCtF53jUBvQMX+zgPZ=YxCwGHyP-8JMx=++d5sCiCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318700844_3703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 15 Oct 2011 13:47:24 -0400
Message-ID: <30270.1318700844@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4E99C740.00BC,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318700844_3703P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 15 Oct 2011 13:45:27 +0200, Markus Rechberger said:

> The log files and demonstration video say something different. Plus
> the same happens with MacOSX. And
> Windows is using the same. So that means that something has been
> overlooked so far.
> The =22off-by-one error=22 must be caused by something. In practice it
> doesn't seem to be relevant as all
> other USB stacks can handle this.

It's quite possible that what's being overlooked is that the device
only accidentally works with OSX and Windows?

--==_Exmh_1318700844_3703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOmccscC3lWbTT17ARAtGZAKCXPUnW37SDPJxhXAdSXjqCubFibgCgs4AW
0Zoe9PzL/9susuUsQtFHmgs=
=Guhv
-----END PGP SIGNATURE-----

--==_Exmh_1318700844_3703P--

