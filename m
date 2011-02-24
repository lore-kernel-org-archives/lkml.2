Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1BXNFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 08:05:50 -0500
Received: from gw3.lbox.cz ([62.245.111.133]:37581 "EHLO pcnci.linuxbox.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751919Ab1BXNFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 08:05:47 -0500
X-Greylist: delayed 1369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Feb 2011 08:05:46 EST
Date: Thu, 24 Feb 2011 13:41:51 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Avi Kivity <avi@redhat.com>
Cc: Nikola Ciprich <extmaillist@linuxbox.cz>, KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110224124151.GK25673@pcnci.linuxbox.cz>
References: <20110223234258.GA29548@nik-comp.lan> <4D663044.3080000@redhat.com> <20110224104800.GA29840@pcnci.linuxbox.cz> <4D663886.6080803@redhat.com> <20110224112742.GB29840@pcnci.linuxbox.cz> <4D664E85.8070808@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ofZMSlrAVk9bLeVm"
Content-Disposition: inline
In-Reply-To: <4D664E85.8070808@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ofZMSlrAVk9bLeVm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Yes.  If you have udis86 and udis86-devel installed when building it, =20
> it's even better.
yes, now I remember! I've done some tracing for You already..

> You don't have to execute qemu-kvm under it, if you have a running =20
> instance you can run trace-cmd in parallel and it will record whatever's =
=20
> happening.
I've uploaded the report for You here:
nelide.cz/downloads/nik/report.txt.xz

> The trace-cmd output will show.  Please run trace-cmd report afterwards =
=20
> and post the results somewhere.
OK, I'll prepare some new windows testing machine, try and report..

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--ofZMSlrAVk9bLeVm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk1mUg8ACgkQ3xdJJrLygV4lXACfejQQTEk3JordUcTyDD4lO7wB
td8Aniaxt+WpFuYxEMXq6Vgr+8KAUUC9
=Zbbc
-----END PGP SIGNATURE-----

--ofZMSlrAVk9bLeVm--
