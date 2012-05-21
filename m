Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab2EUIkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:40:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43245 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab2EUIkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:40:15 -0400
Date: Mon, 21 May 2012 18:40:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-Id: <20120521184005.3b7661ec6468c5878a22615d@canb.auug.org.au>
In-Reply-To: <4FB9F818.4030801@linaro.org>
References: <20120521134219.6d6396802bd6a097503bac92@canb.auug.org.au>
	<4FB9F818.4030801@linaro.org>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_18_40_05_+1000_nYYBnafShDNxVxpQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_18_40_05_+1000_nYYBnafShDNxVxpQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

On Mon, 21 May 2012 09:08:56 +0100 Lee Jones <lee.jones@linaro.org> wrote:
>
> The patch itself has had extensive build and run testing, with DT both=20
> enabled and disabled. I'm guessing some other changes may be having and=20
> influence here. I'm happy to take a look for you. Can you tell me where=20
> I can pull the offending branch from please?

The mfd tree can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git#for-next

Did you try building it for X86_64?  What failed for me was an x86_64
allmodconfig.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_May_2012_18_40_05_+1000_nYYBnafShDNxVxpQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuf9lAAoJEECxmPOUX5FErf4QAKkv9ZQ/7sQS1WnovuN9P9Me
QYS9l4FE2sKd5fYH10xyd0d0lgL9Z/c0BnyJkBm0Exlu34q6fC7fraU8iL4U+85L
g4gY33yvMdemSoo8y4g0PM9tzVANCFzZgUu/NcyCO8wwAhS0U/l9Yn4IBJyo9tIG
iLQCkg/Ldw+rjVimHj4pNN+FgxznnLNrD/HL/WKHv6rtaIFDlBN94csJSDJ8la+L
lUh7WeIpUVo1qEH+BYGjhdroE9lEl+8LmQ8tnCZQOd1/z1xNHoWjfMuI7vtFJkvA
EmT5LAMBVgf0UmxwfxDSeufbslKNRJWLgIWwifWUNOUzRpEoH7UNvofXXcWSXeZg
2s1soWwNUfb0fYPZ/4/v6LU9arS7LMNBAeGBVf2EacPZxKft3eh6ifIsk48080rx
7AXqOc2DKTo5bvoTt7ywp6At0aDtsuJMgjWfceqcakMSvac4qKlp4JesR5lDYj38
fo1h6C0AawE/dYeQinp+yVUj6x0jOBvJ3lb7rD46x0JWThp3HU9ZCS5ZTJw69Adj
c5VodSAuCfCX3chjBQNwae3+XddrHvN6qJWdPAKdPGeXkSEc3lF8zEn6pWjYw45W
dOW2+j3BBkOOsx5lK80fyXuEmOWfr/wBrkzWb1Ilv0jKQLfe2n/rwllV9R5FSnuY
0gf5JLzf9jOSPfTaPR++
=Vv2e
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_18_40_05_+1000_nYYBnafShDNxVxpQ--
