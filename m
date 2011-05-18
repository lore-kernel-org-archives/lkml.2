Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1ERKRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:17:11 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:59577 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755328Ab1ERKRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:17:09 -0400
Date: Wed, 18 May 2011 13:17:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 7/7] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110518101656.GM11981@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305637403-3832-1-git-send-email-tlinder@codeaurora.org>
 <1305637403-3832-8-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WU3I8Do+sziGY3UL"
Content-Disposition: inline
In-Reply-To: <1305637403-3832-8-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WU3I8Do+sziGY3UL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 17, 2011 at 04:03:21PM +0300, Tatyana Brokhman wrote:
> This patch adds SS support to the dummy hcd module. It may be used to test
> SS device when no (SS) HW is available.
> USB 3.0 hub includes 2 hubs - HS and SS ones.
> This patch adds support for a SS hub in the dummy_hcd module. Thus, when
> dummy_hcd enabled it will register 2 root hubs (SS and HS).

I think you should split this patch. One which adds this dummy_hcd
structure and moves the fields from struct dummy to dummy_hcd and
another which in fact adds SuperSpeed support.

--=20
balbi

--WU3I8Do+sziGY3UL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN05yYAAoJEAv8Txj19kN1I2cIAINPgFYJ5JPr6Rk/q2OHQkwC
Z6ftyIM6vzpNjsAohHOJOLcXib0S2mG9dq7rtgnEqqkRCYLNndQ7rchRWmhmgC1C
9ylCNBPsYixdfvTE5XnhtJl/IMYcOxnQOH/13cbNGZ4hO04n+rKWVi1rBy8W0fTm
ai29bOtBjJtynQNwAfnb/ea/K7YDgJLJw8MD3Sdt929JjmcImoHKlOzSrOsRg2Og
J37kEQQR27xjUT6TjdvZqIIr00KVj8WIdjYuPTrWTm0mv2faqY8D5WycrIcu0wcf
n1ybJWP8v5RllQZk4Z6tpq+rsOu6KLy4qNlmwCr1gNqYEPI5Fi/7xGsXzPEOr/A=
=eiUN
-----END PGP SIGNATURE-----

--WU3I8Do+sziGY3UL--
