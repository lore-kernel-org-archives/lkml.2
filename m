Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2CLRPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:15:31 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:55637 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2CLRP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:15:29 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Carsten Emde <C.Emde@osadl.org>
Cc: David Airlie <airlied@linux.ie>, Thomas Gleixner <tglx@linutronix.de>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers-gpu-drm-allow-to-load-edid-firmware.patch
In-Reply-To: Your message of "Sat, 10 Mar 2012 21:20:15 +0100."
             <20120310202241.764367925@osadl.org>
From: Valdis.Kletnieks@vt.edu
References: <20120310202014.828058552@osadl.org>
            <20120310202241.764367925@osadl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1331572450_2731P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 12 Mar 2012 13:14:10 -0400
Message-ID: <9794.1331572450@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4F5E2EE6.0104,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1331572450_2731P
Content-Type: text/plain; charset=us-ascii

On Sat, 10 Mar 2012 21:20:15 +0100, Carsten Emde said:

> EDID data source files are provided for documentation purpose and as a
> template to create EDID data sets for other screen resolutions. Note
> that source compilation is not part of the build process, but needs to
> be done manually, e.g.
>
> #!/bin/bash
> cd firmware/edid
> for i in [1-9]*.S
> do

Would it be possible to include a version of this patch's Changelog as a file
under Documentation/fixing-broken-edid.txt or something, so people don't have
to go and find the git commit log to know things like "you need to run
dos2unix"?  Be a shame to have a changelog that does such a good job of
documenting what you need to do, and have it lost in git...


--==_Exmh_1331572450_2731P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT14u4gdmEQWDXROgAQJUjQ//Q80qSvAYZ5Rr1CMUWWO/ZVaTUrIYqusW
Mo2WrQwxi0uA12Up6GUImoW3TPLVsOibma6dpaW20lV/ScfWaMNaKlBPMa1kQolM
sEiQxbCB2FdFxmcoKww7xcIc+uL5styiAWM9o1dgAU3Q/EdI6rdMIchDfeMY6rAV
UBPCcivcIr6EC9Ro785ZBfE7l27+CUyQXrVS+KjPRdHvXk+7HIdWe9lsuvDLkTE5
fE0SXg0JgH1O0S1S/wRHfxMjZEllHwHpLHv4OdsooSTDwzFAWzoy5r5z7gxaDmUC
BtABhnmmjy5kCSp76Xx0F7/5ALvJ61tB+NJnB4RBQ2uM8A1SQl786WE76HPoLfJ4
WFycxwHXsg5xlRaO8TiaE+4wxkdhBkYmQnlqws+Ul13i3gKo1pSWjB8SHk5tJzR1
x7JtxIsoFW/vyQsclr0x04U/s3HU7hEwBV+MSqSuD9biZkGGYAPJcr0Fef37u8YP
nwiizNj79W7zVfGwyNoU0iaRzjVlWZIztmb0dx/vrnCWM/0L57JpxdlR93edcoLw
w4ZhM/+/6tJlRglIxZmihJMt/OCvWfaGtBtbsNrBExdQPRm+1KsUz6Is0i9y1FMQ
5pSlO3h/PyQouxxP5KkNxyqgmlxWHCp06LTfDUXVYSfeMygxtQcjBKXiYzfmCeLK
JIHPXiLsFA4=
=QA6z
-----END PGP SIGNATURE-----

--==_Exmh_1331572450_2731P--

