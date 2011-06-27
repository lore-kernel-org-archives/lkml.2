Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab1F0Hm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:42:58 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:38301 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab1F0HmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:42:23 -0400
Date: Mon, 27 Jun 2011 15:42:12 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Mandeep Singh Baines <msb@google.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3] crypto: sha1: use SHA1_BLOCK_SIZE
Message-ID: <20110627074212.GA9289@gondor.apana.org.au>
References: <1306379477-24552-1-git-send-email-msb@chromium.org> <20110525.233411.1372538972166578285.davem@davemloft.net> <20110526232058.GQ11023@google.com> <20110531052245.GA17068@gondor.apana.org.au> <20110623190227.GH13916@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623190227.GH13916@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 12:02:27PM -0700, Mandeep Singh Baines wrote:
> Modify sha1_update to use SHA1_BLOCK_SIZE.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
