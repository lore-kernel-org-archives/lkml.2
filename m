Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2B1Jma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:42:30 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:42920 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab2B1Jm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:42:27 -0500
Date: Tue, 28 Feb 2012 12:44:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Rusty Russell <rusty.russell@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH 1/2] vmalloc: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
Message-ID: <20120228094415.GA2868@mwanda>
References: <1330421640-5137-1-git-send-email-dmitry.antipov@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <1330421640-5137-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090206.4F4CA17A.0051,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 28, 2012 at 01:33:59PM +0400, Dmitry Antipov wrote:
>  - Fix vmap() to return ZERO_SIZE_PTR if 0 pages are requested;
>  - fix __vmalloc_node_range() to return ZERO_SIZE_PTR if 0 bytes
>    are requested;
>  - fix __vunmap() to check passed pointer with ZERO_OR_NULL_PTR.
>=20

Why?

Also patch 2/2 should go in before patch 1/2 or it breaks things.

regards,
dan carpenter


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTKHuAAoJEOnZkXI/YHqR7gEQAKXdqWxkqn0+HkEpP5H2TEtP
VPcccVcsznDaGeH/CP9eeg5ti6SzCBA/18qBVD+99PQpePWHOKGx1u7nAM9qe2jp
ayWOTLt919NmDpgKxY76w/KjXfYI0RzMVjHagLLIiwzfQcovVJ1j45LrW6z95b28
uYMvAOkuk+4giw8xiddJGx8sThneSh/F1ohdRzU3fjxdmQ5W0ybNexMrjkcIHP0Y
wBl2Bh8+TpwAEZ4zQmflGSJTwhYB/2H94rV0KS4hBabhE+mAgIASMH6KDtAn/9oD
2RRpY2kKuLjZkPo5XwM7gdXtEtDBVPY2XAI7peXOBeV9h6BvJJJbDXfnxJZlfb6l
6quv92OLFknXB4/ZwsmG3p3JZPoMUgtr399nlBHSv75X3lVPox3PvNJOBP10GFzJ
tbqa1PjF6+9e8It7Y9g2F+Hpvl0H3EFRKWafjkql0F/ORzx9O0LLyOAGsYL4xSLb
YPrblXzpXq4nQ0ZdYSBe9evOpT370n0QEcLuXdL1/vsILeXYCQO0ng+CDJSEIMRL
cQhDX+eW9tf3doX2OH19MZUqhAA/lB7ErzHg3AQla6rjcRPFKGhv+xdyyrEyAtQH
+2b1C/e7Zv7iGoX1j9fh84ZdR11rFaWar56ru/Ry55Jw9ui+PdAhHlLwSE/VVz7J
q6BFXIAn1wVP5zmlOE3i
=HM0v
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
