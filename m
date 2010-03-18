Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0CRVY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:24:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53504 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0CRVY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:24:56 -0400
Message-ID: <4BA29A19.2050307@fami-braun.de>
Date: Thu, 18 Mar 2010 22:24:41 +0100
From: michael-dev@fami-braun.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.8.1.23) Gecko/20090817 Lightning/0.9 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUG] SLOB breaks Crypto
References: <4B9E38AF.70309@fami-braun.de> <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com>
In-Reply-To: <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/RzlL6EoIj0pPgerBYnpnPcgxSEnTmaWZ9bek
 4RGTlyYUOzmLaRSiPTLHcM9+1zhahqNCGoHHxxbVSMwwYdaxvA
 dVbiU/OYvQv0hrlca1i9Kbukw5+7Z15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pekka Enberg schrieb:
> Even with CONFIG_DEBUG_SLAB enabled or with CONFIG_SLUB and
> CONFIG_SLUB_DEBUG_ON?

no, these options have not been / are not enabled.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkuimhkACgkQ+6sI4XSM4u1jtACfS9YfQfKZ/Pu/n62lT50xSise
RdAAmgMfVmKXPFRT2hz7bSWAMIor9zTo
=gMEL
-----END PGP SIGNATURE-----
