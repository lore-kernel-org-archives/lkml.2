Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2ETRXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 13:23:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40664 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755646Ab2ETRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 13:23:43 -0400
Date: Sun, 20 May 2012 18:23:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] regulator: tps65910: add error message in case of
 failure
Message-ID: <20120520172340.GD9337@opensource.wolfsonmicro.com>
References: <1337530730-16605-1-git-send-email-ldewangan@nvidia.com>
 <1337530730-16605-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Content-Disposition: inline
In-Reply-To: <1337530730-16605-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 20, 2012 at 09:48:48PM +0530, Laxman Dewangan wrote:
> Prints error message whenever there is failure on resource
> allocation.
> Also used dev_* to print messages instead of pr_*

Applied all, thanks.

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuSiOAAoJEBus8iNuMP3du6IP/RPUuUMzFawQHuKKORLYxUJT
CZUmi8b5rTMopyUJKR+MmmN9keLaqiDJnpzv+96a5ub1mMSdKXfPeBp0lTpYzTia
wZPuTqTU/kJn2oL9duA9zvQMqlVjPnCX2JHQCpsdKHt7DH8Fn+psKy3dLJNH9Rmj
uUR/Vcmq0wJ0W4aRJKGrUSMwdo4l6vNz/EXLRmU/Krlvc4dKPYlJUvihEzccmWNp
clnt3iVUj1+lnhRm76DRCZo28IPxHVDscAn/a1EbzvGS9TCwzSrV5FX6W8dt66lI
F17Jq0WsqeFTc5yuXQZaOemVaLHDa9nPojCmY1FFRSaY7FDn+dj8sTafTwFAXLNB
M7bcrZID6SsCj4Cx2AVFzdKqUoSVvvRajegGO5tLWwTFhriC7mAD0ViaXsHo3lSO
rwL5o7+R4mKBOoyH2R9UqX/5RZS5eBVdfUAaKnZLHHC4u3Oh2pJa1vT6+Tu6M1W8
wPBgQnsyUe5OdYSdGMsW2F875sD+V9lfyowzBJzgpyw//m6OE0MGWQVyiPLERmBe
4bgL1VgwKdZ+WNHwNzdiDwAuEmjMOvKHmfF61l4JWpdRhn4NylOcj8A2G10U1VXh
vnFmHV/SAxx3zZW7mCGHUiKCO3POg+JrpvCMziGQkGtMBXbqDdvBS7OLhSutPDZO
qG4enulIhjIiD3hp1yT+
=UdlK
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
