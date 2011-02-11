Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab1BKOsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:48:14 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23766 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab1BKOsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:48:12 -0500
Date: Fri, 11 Feb 2011 15:47:03 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "Paoloni, Gabriele" <gabriele.paoloni@intel.com>
cc: Pavel Machek <pavel@ucw.cz>, "Struk, Tadeusz" <tadeusz.struk@intel.com>,
        "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>
Subject: RE: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
In-Reply-To: <DF7BB929B28FCF479E888E3D9F8D9E88F3E2E668@irsmsx502.ger.corp.intel.com>
Message-ID: <alpine.LNX.2.00.1102111546310.13370@swampdragon.chaosbits.net>
References: <4d502ccb.p+rKcuFjWCnBlXY9%tadeusz.struk@intel.com> <alpine.LNX.2.00.1102071922220.27796@swampdragon.chaosbits.net> <20110211142647.GA3920@ucw.cz> <DF7BB929B28FCF479E888E3D9F8D9E88F3E2E668@irsmsx502.ger.corp.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011, Paoloni, Gabriele wrote:

> Well anyway I think that the return value of "ablkcipher_request_alloc(ctr_tfm, GFP_KERNEL)" has to be changed from -EINVAL to -ENOMEM in case of failure. That is why would stay on the patch that Tadeusz proposed. Otherwise Juhl should send another one....
> 
I'll take a look again later this evening when I get home from work.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

