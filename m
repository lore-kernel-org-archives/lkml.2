Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2HCNjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:39:35 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:55274 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052Ab2HCNjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:39:32 -0400
Date: Fri, 3 Aug 2012 16:36:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 11/11] arm: omap: phy: remove unused functions from
 omap-phy-internal.c
Message-ID: <20120803133602.GM8269@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
 <1343639400-28725-12-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3FyYKcuUbgqNYeqV"
Content-Disposition: inline
In-Reply-To: <1343639400-28725-12-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3FyYKcuUbgqNYeqV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 30, 2012 at 02:40:00PM +0530, Kishon Vijay Abraham I wrote:
> All the unnessary functions in omap-phy-internal is removed.
> These functionality are now handled by omap-usb2 phy driver.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Great stuff. I'll take this when we agree on the omap-usb2 phy driver.

--=20
balbi

--3FyYKcuUbgqNYeqV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQG9PCAAoJEIaOsuA1yqREkZUQAKoAZeFRRrXswNe86amI36rQ
OclflUTDHbsnhHA1EBdHvihsKXc/WKq5rjFoTsd1aXNWohGG+6pwyZTxIy5ACkJW
FlCT8Xjf9nKcrc3V1kvymc+OsQvAVFdLKAx4XqY/EY+FW/0W+w+rphR2x6JlJg+K
wBw0YP9cxbAIbiMuV6yIqXrxB0IYYkiYHpchaaDtSAOSxscIGXLMZKR5VwajwcGl
77LzEX4Ei8S5JweQVfeARA0njHTJ3ozoaIaBU3HWq6w2zmGwR1xK1kXeuotWo0Lg
V/Y0PxsT1utnQbcVQRUpaIzW1wUCJCCvjBhoLBukOdcIqKumaFkPHJv5GLSNAQGi
W3goQjhVK3rRnzZ/QdMeB0a2KMs2ht5guFa8K8HVVteMrcNTFa3yhVC5TNxXoHsP
fS/AkOifWD9P5qFjbSc+rQatE+FsgySQvGc1OHaToQmWlqQb68Juu4VUvVkdpvaf
NA90AN/36TmtVf3x5Rs/3UvQTPle+eUNC/zhIDbi+vwHI25ELSW1hsY3RtIob3XQ
JLxzKlzzSoANNgAPVTpobjExUxLL/6/8UW58kSJ/rGgMgwn37kz4VBJllK5oGMUf
YMmhmXvXoLFmAvYl+cSmvfyiZFo7+pZEkbSSzuIaR9Nuz0T01QF6TeigsT2PPagH
kl3AjBXwxjw+S2Edc1fL
=wAEp
-----END PGP SIGNATURE-----

--3FyYKcuUbgqNYeqV--
