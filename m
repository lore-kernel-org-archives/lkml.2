Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab2JKU2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:28:44 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39874 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2JKU2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:28:42 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Jay Purohit <jspurohit@velocitylimitless.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iPhone 5 support for ipheth.
In-Reply-To: Your message of "Thu, 11 Oct 2012 14:55:42 -0500."
             <CADx9NEeyPUNrOiWHn97eOTp5skBqa7D9t8m_90QDAgs+kKtybg@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CADx9NEeyPUNrOiWHn97eOTp5skBqa7D9t8m_90QDAgs+kKtybg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1349987288_1985P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 11 Oct 2012 16:28:08 -0400
Message-ID: <124496.1349987288@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.50772BD9.008F,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1349987288_1985P
Content-Type: text/plain; charset=us-ascii

On Thu, 11 Oct 2012 14:55:42 -0500, Jay Purohit said:
> I noticed that the iPhone ethernet driver did not support
> iPhone 5. I quickly added support to it in my kernel, here's
> a patch.

Missing a Signed-off-by: line, and should be cc'ed to netdev@vger.kernel.org
so the network people see it.

If you fix both of those, feel free to add this as well:

Acked-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1349987288_1985P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUHcr2AdmEQWDXROgAQJrBw//cMYGajR1HtWFMwtOkaqt7zSE0NNthyw+
2Jt0S0qAPIZ4NhGPFkvL5iJH2Kacd2X9RzO3c+s91LidqBHgZdR3Iy+PQ11zmDfU
JOkw2U2V7sPS/fA3shSJgWQz6pHoVSe7y2jO5+PSj9fNwUP3EDuhHZWrVIRlw3mt
MCFmeRnJDn1BJPS4q60h5inYB3eyd7bLY1C7xFRSe1RzsaUAY55lcSeT09viDium
ZAi0ogacrcFk9wmE4e8dY+aqcOs4UW5HDK1KhNbI2v08L2tEvClsdugZM+AtYvw7
pKaNtU30o1zKAtENNEgMgJxE99nEaahxB7B9Ig06r/1DZ6II8CvdfzPvNGgvmG2C
F92uS+/tXju3R9yYEsssnA92NZz4OZ9x3/55UXnCA0cOaH5+6rwc09Mv75mpK5da
TPkqwWKNJdBEu0/qQKKVqRZO9xPr/DAfAdA7ANfFx5i0i1ZoNjSMn3eE5t040S+w
uAYpCOYCUA+ugHONMNIQYK4coxu1Q8Z8pCe9juUX0ayzc/Z2EnInJAhdRlXyrET/
O2i9+cXd2AyDFT/Jz4v8dMyjw4UnzSV5DwSNC77/lL+oxxdU0Shk2mXPLrClwW5Q
JV6JlovS8YdZ3lHlFyIizCd4zmBuvMmbl0DyD8Z6t3QIfKJua42vJrgKOubXr3LE
Tj5etLH9ML4=
=/7L4
-----END PGP SIGNATURE-----

--==_Exmh_1349987288_1985P--

