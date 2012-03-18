Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab2CRClU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 22:41:20 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37690 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2CRClS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 22:41:18 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Carsten Emde <C.Emde@osadl.org>
Cc: David Airlie <airlied@linux.ie>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Packard <keithp@keithp.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [V5 PATCH 1/4] drivers-gpu-drm-allow-to-load-edid-firmware.patch
In-Reply-To: Your message of "Thu, 15 Mar 2012 15:56:24 BST."
             <20120315145827.772186873@osadl.org>
From: Valdis.Kletnieks@vt.edu
References: <20120315145623.486070468@osadl.org>
            <20120315145827.772186873@osadl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332038368_2016P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 17 Mar 2012 22:39:28 -0400
Message-ID: <59418.1332038368@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4F654AE3.0072,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1332038368_2016P
Content-Type: text/plain; charset=us-ascii

On Thu, 15 Mar 2012 15:56:24 BST, Carsten Emde said:
> Broken monitors and/or broken graphic boards may send erroneous or no
> EDID data. This also applies to broken KVM devices that are unable to
> correctly forward the EDID data of the connected monitor but invent
> their own fantasy data.

>  Documentation/EDID/HOWTO.txt        |   39 +++++
>  Documentation/EDID/Makefile         |   26 +++

Documented *and* a Makefile to automate it. Nice. :)  That addresses my
comments..

Acked-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1332038368_2016P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT2VK3wdmEQWDXROgAQJTuw/+KdVA98h2rcuSxFaFCa20qH4iiMRosxJW
RZyhCsq9IWAkTP8AN7v0vmwcCh++fIije4JNyIpFjUfPm/SCbPre/TXJ+XWqAIG5
WGvWsLPLCCpnWWkXdNllYAJnJXgRhMVUnIEQuTY0u1weYRfFo4fuqwnkLHZtx7b/
8Aeu3VVoItuUhXe+9B7D5ruN2GWpxgdpx6OwbZYcoWYdxj7MafWiHutYwy70gfBh
SGC3gEnPphxjBUlBfqQ5OC/q/BX0NsLBfRcQ/9XB95gohsQVDxWG3kCN3Qm6jjn0
uzuPRYLksvCYDgzqJC4hL8oQjyg9x3qtQo23O7w5MyHlcr/DZwLIYJe669yCb4Lj
+sXgeEzzFQgYslpAwWPpcF9qlnDQE1V8PqXa3PmuqzHCal9KsaJUVrQPt+hegmBk
XZj/j1VlRVESoNatH2/daLPctErXatMcIEoqQOyMBy+tcuslAIzNxHFAbauOEpMN
dy544TQa3qfmawNokx5j1rYqliB6N81i4x9t/PZlXFg0YKs4IuxynKifAkkRSTgW
F6GVgDi90g/AGYg/FA/SPSTkZLwfYWxxKtwFZoWOlqzajBSFAGIeCPCUrAPPMl8G
a5leVX8xGw1LQQ7/nJ+SMIrAPNJ5S9klXgC54eyYtxU8jjDBO2GSLtVLEsJtHdoA
MeEKXF5p19s=
=ZSS8
-----END PGP SIGNATURE-----

--==_Exmh_1332038368_2016P--

