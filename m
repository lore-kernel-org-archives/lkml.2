Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0DBBJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:09:35 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:58146 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756578Ab0DBBJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:09:32 -0400
Date: Fri, 2 Apr 2010 09:09:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
       Henrik Kretzschmar <henne@nachtwindheim.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: section cleanup
Message-ID: <20100402010912.GA27103@gondor.apana.org.au>
References: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de> <20100329081550.GA22334@gondor.apana.org.au> <20100331145817.bd0a1a08.akpm@linux-foundation.org> <20100401081126.GC23247@secunet.com> <20100401145953.c626d731.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401145953.c626d731.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 02:59:53PM -0700, Andrew Morton wrote:
>
> - What's all this reordering stuff?

Padata must guarantee that even though the work may occur in
parallel, anyone submitting work to it in serial must observe
the result strictly in the order that they were submitted.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
