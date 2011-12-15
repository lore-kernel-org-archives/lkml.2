Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab1LOFdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:33:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab1LOFdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:33:41 -0500
Date: Thu, 15 Dec 2011 16:33:26 +1100
From: NeilBrown <neilb@suse.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: md: Fix userspace free_pages() macro
Message-ID: <20111215163326.54bdd6fc@notabene.brown>
In-Reply-To: <4EE911F3.4020502@linux.intel.com>
References: <1323869678.23971.19.camel@gandalf.stny.rr.com>
	<4EE911F3.4020502@linux.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/y6=9og1T3+sR+jZVxhiNaGb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/y6=9og1T3+sR+jZVxhiNaGb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Dec 2011 13:15:31 -0800 "H. Peter Anvin" <hpa@linux.intel.com>
wrote:

> On 12/14/2011 05:34 AM, Steven Rostedt wrote:
> > While using etags to find free_pages(), I stumbled across this debug
> > definition of free_pages() that is to be used while debugging some raid
> > code in userspace. The __get_free_pages() allocates the correct size,
> > but the free_pages() does not match. free_pages(), like
> > __get_free_pages(), takes an order and not a size.
> >=20
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> >=20
>=20
> Acked-by: H. Peter Anvin <hpa@zytor.com>
>=20

Applied.  Thanks.

NeilBrown


--Sig_/y6=9og1T3+sR+jZVxhiNaGb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTumGpjnsnt1WYoG5AQIWoBAAwrqNSgqSuO6Y/GKAP8aRmL0p81nziH8K
JSiW2BIU/9tHuUhb1vQBy3D5ypPZ+LpsMZ4eIxMmwC0hraok0hys5pxhTDbYPKVo
gjKtN21dcn8in+hCG+gWNtugHo/+MNhMxoZqWOW731zffTv3LO/ZaGhwrws9YqYV
/qsmai8QAHRWJMHawOp7kS2fJPhOHlaHU8YnDJu57Jp05ulWS4lrpgTBPDY8faOH
2vCj43DJqz5nWFzqfK8K8U7oMPamCsalEyyq9WgInHvmYMifxIIeiCHsbCaYiDVu
2tu5hxUXRHQI6ShBcoOjqHv9lrxzJBoN8xGl0tN3sWRc7DADwExUITDfbueLI+Ns
5FFiGll3Q+Z/tGu4j/D9BhKrZHoniaDuJml6k+rjC1jEG9UAszndsHyPp8sH6KFg
HMOPWq/xNcaOWnBUtxnskYxIPfWcZN3yGSV+erWd7hZF1ELoLBpLmaqjIS8Q8PNO
SYIP31w07pstpdbqdptc1nBhEQpoWc18ebH/Iv2LpXot6saQcbIDpk4R0h327TrS
MufEcaK2pA9TPLNzJbZ0ZeU9c5DczHa0A1+q1ORW4DpkD5xked3TUPmLs+ow0k7c
80JrJu5tByZvaJEsmfZVXC/y5MWB7NJcJ9xdBVAIm1mOR9eaFgrvvdp+PLgHkDG5
LrTzPCnFLM4=
=RyvC
-----END PGP SIGNATURE-----

--Sig_/y6=9og1T3+sR+jZVxhiNaGb--
