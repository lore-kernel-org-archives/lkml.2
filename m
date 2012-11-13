Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2KMIvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:51:37 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:40913 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2KMIvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:51:35 -0500
Message-ID: <50A20A15.6090506@atmel.com>
Date: Tue, 13 Nov 2012 09:51:33 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>, <linux-next@vger.kernel.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the pinctrl
 tree
References: <20121113151754.98aa6471baaf062826c3b133@canb.auug.org.au>
In-Reply-To: <20121113151754.98aa6471baaf062826c3b133@canb.auug.org.au>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/13/2012 05:17 AM, Stephen Rothwell :
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in 
> drivers/tty/serial/atmel_serial.c between commit 784557decc48
> ("tty: atmel_serial: add pinctrl support") from the pinctrl tree
> and commit bcd2360c1ff9 ("arm: at91: move platfarm_data to 
> include/linux/platform_data/atmel.h") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no
> action is required).

Stephen, it is the proper merge.

Thanks a lot.

Best regards,
- -- 
Nicolas Ferre
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQEcBAEBAgAGBQJQogoUAAoJEAf03oE53VmQAt0H/iThKsKe+ag10z9Q8xlO6sqR
dvfFtRQxv7W1xVeRc/RJjnE/thKaa+FMiUfvFoj4Gls6UZD3vAvwatI+kkGY30yp
FbflguygU8OvAQcr/dpVx2tBzsqCk7Xynk+D0+DjlJXukP+JzP+3/tl7Gd0/lct7
nLccb1X0sNwTrvlLJO2WJuOGwFlTU3vO1wkehgic2ozfm3FzsaTLUjkUf6YXOG1N
BoABfHJL0PyNk6iENu26j6ulDPaWrpJe5531hTcJm16X+h2gnmnnjpYw9dTTQ5qO
La0UeqkqTxEUOFmo3cxbS0ryBeQBTmHss61JLVcqnlwApTscefmD4x8G310D7oA=
=mEy6
-----END PGP SIGNATURE-----
