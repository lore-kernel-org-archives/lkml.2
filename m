Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1JQPF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:05:28 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:6838 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1JQPF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:05:26 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zzzz1202hzz15d4R8275bhz32i668h839h34h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LT7TWU-02-IFJ-02
X-M-MSG: 
Date: Mon, 17 Oct 2011 17:05:03 +0200
From: Conny Seidel <conny.seidel@amd.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [00/38] 3.0.7-stable review
Message-ID: <20111017170503.7bd4bce8.conny.seidel@amd.com>
In-Reply-To: <20111011170026.GB31075@kroah.com>
References: <20111011165903.GA30976@kroah.com>
	<20111011170026.GB31075@kroah.com>
Organization: Advanced Micro Devices GmbH; Einsteinring 24; 85609 Dornach
 bei Muenchen; Geschaeftsfuehrer: Alberto Bozzo; Sitz: Dornach, Gemeinde
 Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
X-Mailer: Claws Mail 3.7.10cvs30 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/jMlqjv6LJYavJWYpyILDwJq";
	protocol="application/pgp-signature"
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jMlqjv6LJYavJWYpyILDwJq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

is there a reason why the v3.0.7 tag is missing from the stable
repository?


[/build/linux-stable]$ make kernelrelease
3.0.7+
[/build/linux-stable]$ make kernelversion
3.0.7
[/build/linux-stable]$ git describe
v3.0.6-33-g62bf792


regards,

Conny

##
##################################################################
# Email : conny.seidel@amd.com            GnuPG-Key : 0xA6AB055D #
# Fingerprint: 17C4 5DB2 7C4C C1C7 1452 8148 F139 7C09 A6AB 055D #
##################################################################
# Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach      #
# General Managers: Alberto Bozzo                                #
# Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen #
#               HRB Nr. 43632                                    #
##################################################################

--Sig_/jMlqjv6LJYavJWYpyILDwJq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6cRB8ACgkQ8Tl8CaarBV3jnACfY3LcsQhaqfSm/mYwHTsw8hKE
tOcAoJWhh7ErfniAN2B8vcSDjrMpYspZ
=5njt
-----END PGP SIGNATURE-----

--Sig_/jMlqjv6LJYavJWYpyILDwJq--
