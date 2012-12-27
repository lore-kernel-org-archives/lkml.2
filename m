Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2L0RlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 12:41:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52993 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748Ab2L0RlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 12:41:23 -0500
Date: Thu, 27 Dec 2012 17:41:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: andrey.smirnov@convergeddevices.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add "no-bus" configuration for regmap API
Message-ID: <20121227174120.GK5005@opensource.wolfsonmicro.com>
References: <1356083238-6932-1-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qgd2S+2VS1hsWwXW"
Content-Disposition: inline
In-Reply-To: <1356083238-6932-1-git-send-email-andrew.smirnov@gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qgd2S+2VS1hsWwXW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 21, 2012 at 01:47:15AM -0800, Andrey Smirnov wrote:
> This patch proposes extension to the API that was suggested by Mark in
> the following thread:
> http://article.gmane.org/gmane.linux.kernel/1383734

This needs rebasing against v3.8-rc1.  Please also add regmap: to the
subject line - missing that means that things are more likely to get
missed or looked at slowly.

--Qgd2S+2VS1hsWwXW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ3Ig5AAoJELSic+t+oim9LcUP/RFCWOCJZdrCvk0CKupjhQ29
w1eYerIDYI1eYpCEtBeES3viciaSrT/20CcLVOZWNAZcD5O+OC+01a5mo6y/dK8u
LREtIxoKPAXlNkHVfsb4yJGdH0OsjPYW8GBoWiNmXIDvUEdRnsu4pbwE+z+oYhOh
MOAEQyUB5c8zqWO+Is2LoWg0xrACk8uyinGsJMfekoRqlEG7dxNySOYKOOGiZH/1
Xokfq+0n5NrvS9utUxWq4Fzg21NhAeXGF1B9K3DgRynJ5lzw2MSXTyz9x+rDi/0A
8PcD9wjqB1NlC4GP2hyBdzg0EtFldoM5fRWSTUcdhXmLgxPuetDq2VueofSrRRAT
BSF42mXVyuecPfNl7TuJyIXZf4UCcirN3v1SNf5M9r5OgxGCi8Kra3LorwGNFKs0
DhcgJkfqvT9gTYkHT6Rd8ZmfI+NuP79uDXAhfONZFj4rKBA+R9zkBeubjJHQ47PS
IU/FMwWzkZ/XOp2flZrs97VmrXOgCx+7kDLLpDRYlVqfhD0AG12RgCZmWeUxkCof
1Jh5+WAbZzsc2nvLRHQ9e9HHhsUiVcCxe5GspARnNXjRMZwHmfDDLZJVDmPz9HmL
1nQzf70akph4MNzqjGIccWlCGhMCOIVoU92/xiTZeHB3cX2VJ9Zs+fAh25ispUP9
s/A1z0kAP90+6DbtsdK8
=o51/
-----END PGP SIGNATURE-----

--Qgd2S+2VS1hsWwXW--
