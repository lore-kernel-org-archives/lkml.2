Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab0HFI6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:58:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab0HFI55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:57:57 -0400
Date: Fri, 6 Aug 2010 10:57:56 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: typo in crypto kconfig ?
Message-ID: <20100806085756.GA13458@fancy-poultry.org>
References: <201008060942.16082.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <201008060942.16082.toralf.foerster@gmx.de>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100619 (GNU/Linux)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:uPlSluiDwK6DV12HW248B2ezMqqckpJ1KmbfoT/8fQo
 uWjHLYHnf68Iv9swBJBWUQRjK/7vXnEbTDMAMbOICUWgKRs0Rh
 Mn8tC9XMDF84SVNADWEtZQo0WhzY0iv11/Dsj5WK0xk7NOM8um
 3Ya+rVXKG79kjM6zsv3dSmRcXpblYQzU29H0MopvCJvenQCz1a
 opq60kjKdlUy1ze8tI9ZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.08.2010, Toralf Förster wrote: 

> While configuring the kernel v2.6.35-3797-gfc1caf6 I read this :
> 
> ...
> Cryptographic API (CRYPTO) [Y/m/?] y
>   *
>   * Crypto core or helper
>   *
>   Cryptographic algorithm manager (CRYPTO_MANAGER) [M/y/?] m
>   Run algolithms' self-tests (CRYPTO_MANAGER_TESTS) [Y/n/?] (NEW) 
> 
> and wonder now whether it should be spelled "algorithm" instead ?

Yes, that's simply a typo, it should be "algorithm" of course.


diff -urN a/crypto/Kconfig b/crypto/Kconfig
--- a/crypto/Kconfig	2010-08-06 10:53:20.236000026 +0200
+++ b/crypto/Kconfig	2010-08-06 10:55:46.613000033 +0200
@@ -102,7 +102,7 @@
 	select CRYPTO_PCOMP2
 
 config CRYPTO_MANAGER_TESTS
-	bool "Run algolithms' self-tests"
+	bool "Run algorithms' self-tests"
 	default y
 	depends on CRYPTO_MANAGER2
 	help
