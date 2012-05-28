Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab2E1U5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 16:57:31 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:47707 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab2E1U53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 16:57:29 -0400
Message-ID: <20120528235726.11081hnk0322lku0@www.81.fi>
Date: Mon, 28 May 2012 23:57:26 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?b?TfxsbGVy?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: testmgr - expand twofish test vectors
References: <20120528135538.GJ17705@kronos.redsun>
In-Reply-To: <20120528135538.GJ17705@kronos.redsun>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Johannes Goetzfried  
<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>:

> The AVX implementation of the twofish cipher processes 8 blocks  
> parallel, so we
> need to make test vectors larger to check parallel code paths. Test  
> vectors are
> also large enough to deal with 16 block parallel implementations  
> which may occur
> in the future.
>
> Signed-off-by: Johannes Goetzfried  
> <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>


