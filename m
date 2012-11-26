Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2KZKjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:39:45 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:53809 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab2KZKjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:39:43 -0500
Message-ID: <50B346EE.1050306@atmel.com>
Date: Mon, 26 Nov 2012 11:39:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-next@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
References: <20121126213152.60b52e19d7fc84ce94c356c3@canb.auug.org.au>
In-Reply-To: <20121126213152.60b52e19d7fc84ce94c356c3@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/26/2012 11:31 AM, Stephen Rothwell :
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in 
> drivers/tty/serial/atmel_serial.c between commit 95e629b761ce 
> ("ARM/AVR32: get rid of serial_at91.h") from the arm tree and
> commit bcd2360c1ff9 ("arm: at91: move platfarm_data to 
> include/linux/platform_data/atmel.h") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no
> action is required).

Yes, good fix that has to be carried...

Thanks, bye,
- -- 
Nicolas Ferre
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQEcBAEBAgAGBQJQs0buAAoJEAf03oE53VmQMPgH/0Gynlb5BBImnjSU75mh/dPC
ob/lTJv3w/2gUKPqbOgyxTSmMc9ckFcDELAhFYt+df9hKfOMBzZAUPHLEclZolZ+
AqpnIjGq88TYWMgaREUZ2bigTrzuWKqHiIWV/AoNcz2slhWC//CHK6z9SHE7hZOI
zZFwf326v0dRkm4g785cqalg7pNxQDpE6iMZXuifb8zPWePgKBxqHyPRCbhP1dwu
T4XQ3IgnrvzWcqz/V4mr8kppJXzHNfDEsVZ2XfndhUKVFY4qMGZhFBoTlI6LhNWO
Nu2mD7TaENoKRijLYrdMfidJ65uwAGtEWA6UxEfV1VWVddSsi/D8OuniBta+Ewg=
=zF93
-----END PGP SIGNATURE-----
