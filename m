Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab2I0Io5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:44:57 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:36992 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216Ab2I0Ioz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:44:55 -0400
Date: Thu, 27 Sep 2012 11:39:56 +0300
From: Felipe Balbi <balbi@ti.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCHv3 6/7] dma: move dw_dmac driver to an own directory
Message-ID: <20120927083955.GT12592@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348731121-2515-7-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAOh2x=m=14TCV7LEM4zk9Z9KattosnNwR-UvYqe5tNiCksCo0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mgIE+9cwyCTt+85Z"
Content-Disposition: inline
In-Reply-To: <CAOh2x=m=14TCV7LEM4zk9Z9KattosnNwR-UvYqe5tNiCksCo0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mgIE+9cwyCTt+85Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 27, 2012 at 01:52:24PM +0530, viresh kumar wrote:
> On Thu, Sep 27, 2012 at 1:02 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > The dw_dmac driver contains multiple files. To make a managment of them=
 more
> > convenient move it to an own directory.
> >
>=20
> Looks readable now :)
>=20
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> (After fixing Felipe's comment)

And here's mine (after fixing the typo):

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--mgIE+9cwyCTt+85Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZBDbAAoJEIaOsuA1yqRE9kMP/01nHmnz8XThIpdX7TBwxrji
z0jzCpnuicvPH0tN99yKgXXcWq5KvJVCQ+2viYqQdHcxoT9pIfCp1aOG6vv+atZS
7p4zsZwL66+ohy/4gJxsBxckdW4UBy27+fge2yWdM8HEhEKQbC/THfclR6rJVhxJ
1ky1qBNR3KuRHcrwi6SEd2dwQPeMiOExVwcjZBTXCrQyQBAzKQaQ6zajAQOOUG3H
huGccPPd4NG23+u7zwS6t6HRPR8R8zLBK0L/pcEX4VN9nt05aeefXhqUQ8UTLSWZ
hOs4OcaGbTQFK4a4p88NL0+O9kRCqvQYKtrEq70nFRCc9q68vXacHwN6dRQZONal
BXsGnJJ++8O6xBqOOGSgv+eP1ysADtic7fjgcQ5iG5hUJxbYF0H4rbwPBiFcpwW6
iHHNTf4PzHdk+Jvc2hksfmxudy73U/fjFr0R/MkzbLW2+fnngUSqtt/XWlU3izNd
IwGxGW+iT4oTndaceZ3Sv7pCfrXvEyGlnK2MZQhCDET41988OflCeVAIoaPAl1hR
+e6eftMAf/eQRpMtLWriToXTNOzRslWK8jQTIkQkWllGRrTK2zo0t29C7IX0u7rn
WTxKz9NsnMimiCop5pRtFSkcGhqloBRgO/wKZ7IoMbPkPKrEEccj1apAMv9rDcZq
ICPbN614qSSUpAGgq8GL
=sjLP
-----END PGP SIGNATURE-----

--mgIE+9cwyCTt+85Z--
