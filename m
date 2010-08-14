Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab0HNGxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 02:53:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52669 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0HNGxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 02:53:36 -0400
Date: Sat, 14 Aug 2010 08:53:35 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.2
Message-ID: <20100814065335.GA13979@fancy-poultry.org>
References: <20100813212313.GA22102@kroah.com>
 <20100813212333.GB22102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100813212333.GB22102@kroah.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100810 (GNU/Linux)
X-Provags-ID: V02:K0:qYdqT86s0LIXs34I4ix9BK4lcB8iFdKel2FYnU3pBix
 6S5w9qyo3DTFiWNBaAmjrnvXOr5S+KcK8xFF9VLG88P9Ma4448
 p4EpP6nWon+7+w/kd/xAymxVM26Uh45lnNYL33mKhoUxaZKmQS
 yKR3GOCjFeFkULx0vNqjIVV5kibsy69jJHAV/AJxVaJB4s+GjO
 HT2sWNfzLNpOy61UNY8yA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.08.2010, Greg KH wrote: 

> +config CRYPTO_MANAGER_TESTS
> +	bool "Run algolithms' self-tests"

There's a small typo in the crypto/Kconfig patch. This corrects it.


diff -urN a/crypto/Kconfig b/crypto/Kconfig
--- a/crypto/Kconfig	2010-08-13 22:44:56.000000000 +0200
+++ b/crypto/Kconfig	2010-08-14 08:47:17.810000001 +0200
@@ -97,7 +97,7 @@
 	select CRYPTO_PCOMP
 
 config CRYPTO_MANAGER_TESTS
-	bool "Run algolithms' self-tests"
+	bool "Run algorithms' self-tests"
 	default y
 	depends on CRYPTO_MANAGER2
 	help
