Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab2CSJA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:00:58 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:3148 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757744Ab2CSJA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:00:57 -0400
Message-ID: <4F66F5AB.7020600@atmel.com>
Date: Mon, 19 Mar 2012 10:00:27 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the l2-mtd
 tree
References: <20120319174743.aff001d4f84e82cf4042277a@canb.auug.org.au>
In-Reply-To: <20120319174743.aff001d4f84e82cf4042277a@canb.auug.org.au>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/19/2012 07:47 AM, Stephen Rothwell :
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in 
> drivers/mtd/nand/atmel_nand.c between commit 4331c79c6895 ("mtd: do
> not use plain 0 as NULL") from the l2-mtd tree and commit
> d6a016616ba8 ("atmel/nand: add DT support") from the arm-soc tree.
> 
> The latter superceded the former, so I used that.

That is definitively the proper fix. Thanks Stephen.

Best regards,
- -- 
Nicolas Ferre
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPZvWlAAoJEAf03oE53VmQd0EIAKV1xC3F+fd6lvu3rKNyzUl0
yfcvNtc9cFbwuR9A3cbeoCo6FbfdSpsT2eT8v+DZ5LDvPmJ9ln9jgqyldq+QfblU
2KpyOWSLeLpG6ILky7Hlo4tjm1NA3GNZGLpyQ2Yln5r17zeTHqaCBeL+xHXOdgcM
Uvrrix67AmnL91nF4QNPdOfKYnv2h+J2OWW6ukFBajQOMBIiVeddVL62qKYOvq0K
QrgTa5D4cygvD0NUMTrrJ5GXjR+afAL7K5pk0Aab9C6pzgKGVredD5qSu/Zpbn8n
+aHXNyfqLQ9+7++a+hm6VNMTrMZxFo/MZoQZsigu7JkJ8lDTNhsaWkm3QqWl4c4=
=6Y0V
-----END PGP SIGNATURE-----
