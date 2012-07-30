Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab2G3Hza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 03:55:30 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:41251 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752297Ab2G3Hz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 03:55:29 -0400
Date: Mon, 30 Jul 2012 15:55:25 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo Mueller <tilo.mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH 0/6] crypto: add x86_64/avx assembler implementation of
 cast5 and cast6
Message-ID: <20120730075525.GC5515@gondor.apana.org.au>
References: <cover.1342027375.git.johannes@goetzfried-amberg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1342027375.git.johannes@goetzfried-amberg.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 07:36:46PM +0200, Johannes Goetzfried wrote:
> This patchset adds x86_64/avx assembler implementations of the Cast5 and the
> Cast6 cipher.
> 
> Johannes Goetzfried (6):
>   crypto: cast5 - prepare generic module for optimized implementations
>   crypto: testmgr - add larger cast5 testvectors
>   crypto: cast5 - add x86_64/avx assembler implementation
>   crypto: cast6 - prepare generic module for optimized implementations
>   crypto: testmgr - add larger cast6 testvectors
>   crypto: cast6 - add x86_64/avx assembler implementation

Nice work.  All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
