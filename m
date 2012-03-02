Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab2CBW0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:26:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56007 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2CBW0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:26:31 -0500
Date: Sat, 3 Mar 2012 09:26:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: linux-next: boot failure for next-20120227 and later (pci tree
 related)
Message-Id: <20120303092620.ab0f7379afac65413ef5264e@canb.auug.org.au>
In-Reply-To: <CAErSpo6xQa4Rnv+RkkXCRjQ2HDZdBhorRv2c6pmWyXqRzhM4Vw@mail.gmail.com>
References: <20120302170638.3d172369d04335d9b921a28c@canb.auug.org.au>
	<CAErSpo6xQa4Rnv+RkkXCRjQ2HDZdBhorRv2c6pmWyXqRzhM4Vw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__3_Mar_2012_09_26_20_+1100_hRmsrGX2SL+pqi1b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__3_Mar_2012_09_26_20_+1100_hRmsrGX2SL+pqi1b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

On Fri, 2 Mar 2012 10:10:02 -0700 Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> Thanks a lot for the test report and the bisection.  I wish I had a
> machine to test on so I wouldn't have to bother you about it.

That's OK.

> Any chance you could point me at the complete before/after dmesg logs?
>  There should be information about the PCI host bridge apertures and
> offsets in the "after" log.

I have put the logs up at http://ozlabs.org/~sfr/console-bad.log and
console-good.log.  They have been editted to set the initcall return
timings to "x" usecs just for ease of diffing, otherwise verbatim.

>  If that's not enough, we might need to
> collect new before/after logs with something like this
> (whitespace-mangled):

I'll defer to Ben as to whether that would help as I don't have easy
access to the machine until Monday anyway.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__3_Mar_2012_09_26_20_+1100_hRmsrGX2SL+pqi1b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPUUkMAAoJEECxmPOUX5FEEA4P/R8hQpYip0koii300ZCcuonq
3eg4ex1dCQg7hj/Bl+oVk+hEEiH/gnmz4Oqrhpl0fsmtAf9jt+MfguyR9gVCyvXJ
2ap2/XInpiMjj62LLLqHQ+orcfxIGnWuT5Wuh68TT81W6d536IdWWMhHHl/LJb/q
aR9ohvEv0Q4re5lPJeYuFL5wO0rCcdpdB3ZQP7S+u75xgMvDXZ/IrTE7TFUGmEwU
Egqm+kkiylNR+TtemaCa5YYiLcKFWHaK3oLGqaguCUPd7rAO2qKWrQDIvJiUTaAr
upl51Vycc2b7/46kS0LzVah6poNQmSiHnEIC2cq2PAMPui46x8ZqgE3OkpnFX3j2
xhM7pCVlBONH53NNsQhzmwFjUvdwAYqFVHSchpx7oF+5cWp7o7Z0PowbleQYa2Ps
iPvgNp23YUbw0B80B3YnIsOqWC7PVJVDEksWLBPJdRZXPHDM2ZMf0BIm75hW5CSD
mqaCS/pOLfRT9ghs1eGtfWnjxi0/msdGijsJdCR7GqB61XHKoAyWsDBR5RDwN8cd
n4ypm6mzBJzbRVXMdZGPR9Ki4dVvEOF4k8mGLOBEb/tB7Ege1fTS/svQXUqtCus5
+ZOFS8btoIJ/tFlCKkJNRYUb15hQRT+ki6lDz2MeG6eKMsLOxKDtfOZkXQ13fFn9
pY1pabiPsEIb+/aUOVue
=0TEB
-----END PGP SIGNATURE-----

--Signature=_Sat__3_Mar_2012_09_26_20_+1100_hRmsrGX2SL+pqi1b--
