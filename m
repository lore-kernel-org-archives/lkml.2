Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab2FOSIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:08:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49971 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756858Ab2FOSIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:08:14 -0400
Date: Fri, 15 Jun 2012 19:08:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pankaj Jangra <jangra.pankaj9@gmail.com>
Cc: Philip Rakity <philipspatches@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Philip Rakity <prakity@marvell.com>
Subject: Re: [PATCH 1/2] regulator: core.c Pass voltage to notifier when
 setting voltage
Message-ID: <20120615180812.GA18638@opensource.wolfsonmicro.com>
References: <1339711609-3417-1-git-send-email-prakity@marvell.com>
 <CADTbHxq5rmHJtFTp53sYhFSYWVrSqyo_Jq+0aWNOF2HQR+nhGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <CADTbHxq5rmHJtFTp53sYhFSYWVrSqyo_Jq+0aWNOF2HQR+nhGA@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 15, 2012 at 11:28:38PM +0530, Pankaj Jangra wrote:

> I am also curious to know if you pass the  voltage here to notifier call
> how does it make any difference, since in
> blocking_notifier_call_chain() again passes the NULL. So does your patch
> should  modify the arguments to this function also?
> Please let me know if i am missing something in understanding.

Your mail would have been rather more comprehensible if you'd mentioned
that you were talking about the call in _blocking_notifier_call_chain()
(which is obviously buggy).

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP23oEAAoJEBus8iNuMP3dHmcP/31GlpNhrk696wzg0qinfC6F
e8FXFdfPdAHn5GJmKXUf4MS7WHpX4yLqqx/u37NCOn8r8pGN+3BP6bXimgykrgAc
NvvmNfQKfzpp4tkvjsD4khArCVRXom1qldIepiBbSCnDPjDdqz/UJxN9h1vqQqsn
ZDXkC3TyQHOIt2C42iL5r0RKGzgew44GI+XZH8pVtul+6sOHQemsz8/qQVLDArKc
tcGyDakeDwjzrRWdIpPVo/oT5CKnfnNFZRWBk2ZYmUF0OQGHX2dKHabz62UqQk6r
YdvUIvdEfO6anTdK9NcyFok/WpEizRzUE5HeVSUvAqDGLoeU2VLqXxosiBxXrU81
aRSwfnn+dmbvevnF4uME+3aPklSszVI23WXcezn/XDPDYZw8TNOIXwJrqbBYlCis
a2SLGmBWqfYE7ufhhlt5yLn41wZG1Ut7hKip1V2s52VKRXBTGdtCz66yKkRPbk5v
0ohL4tFfwn6J5chul9cll82xaxmTetkqvr0k3BK8OjJ47XzSr/RRoVvePf6PR/s+
FtwJ5klL1G3fVVyvvtnHAlsh6S31gO4E/L7N/d5VSSoWMY8gbcHUisvNj8/HnWkC
qtpSXbI4TvgOwCyh2Wv1YStdhimrC6R2Ov3eexL1t8iCsPIa4STEidRyaw2C4azT
hEx/YrpX6kKQ9Vxw2QX+
=wRLx
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
