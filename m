Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2EVJiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:38:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36622 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334Ab2EVJiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:38:03 -0400
Date: Tue, 22 May 2012 10:38:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: yadi.brar01@gmail.com, "jonghwa3.lee" <jonghwa3.lee@samsung.com>,
        =?utf-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: Re: [PATCH v3 0/2] regulator: Add initial suport for max77686
Message-ID: <20120522093800.GC21999@opensource.wolfsonmicro.com>
References: <4fbb2ac4.63de440a.589d.78cc@mx.google.com>
 <CAH9JG2Xq-4J9Vn6d6cxcMNsZ5Y2LLJG9vrVQWEyPHhNd08ek9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline
In-Reply-To: <CAH9JG2Xq-4J9Vn6d6cxcMNsZ5Y2LLJG9vrVQWEyPHhNd08ek9g@mail.gmail.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 22, 2012 at 03:53:11PM +0900, Kyungmin Park wrote:

> BTW, do you know that you're reviewing the same device driver patch
> from different person?
> One from Mr. Lee and another from Yadwinder.

> I wonder how to handle it finally. which one is choose?

Yes, I realise there's two different versions of it floating around -
personally I'd hope that you guys could come to some agreement about a
common set of code that works for everyone.

--3siQDZowHQqNOShm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPu15yAAoJEBus8iNuMP3dMMMP/jXdSUtUNltFo/Fi6ZVM+tyz
kYlV8QhYYn/qwJsjL5PgHb5pJf95v3QjHJMN9jv8txmA/V2E1JuazBmeKUuMnjTR
QYVZ0UNgOU6mDzOKu+I/vMEmditsQOfz//fMZYU35pe/itj5PNXeYtYk644nsvaI
npPmEb59HenLQ2e9GjoxJPZqaqv6r3WAUnazz/iO1+TOtj/95WjP7kMpqjRhUdIr
aep+R6ASy7iQO8bnyKMT5OKRPOYwPobcaGVZBkRxvPZvVULACHRUDR9sTxR74IbG
FCBPVOK1cO/D/N4okmEyNWZPpaQRHX/WrI5G0plC+DrqBN9EbfhvtI65ljtB0jYD
H2+mATHrlownbWDcBdbfVuVosemnNrzenDX8JdjL+nK1TpmZXErDY/qw28XX3hKt
O2W4Jx13EwSHs407jw08xCWz2YfR1Z/JFzzag5Nij8YMFEGm9yZAhd4zioIoP71g
7ecJJ3BepTr2qVZg6OeIQlLhRTXjWpJaFWsHswqfM4D8UQm1rJgyDMVI68VDErhE
MYpztVtofpmcNw4JL5L7hKwy6XlmIrd3GEh2Pe9jBKI2yx9B52dvzLEpPiW5zmQu
CYCEGHgYUxFwYJ5gYF7PP7MLAnIJnQF8QrYmPGaqo8cK/A44zP+EJTRmII9LiarH
liiDlrENo0q81B2yg/fv
=94WC
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--
