Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab1EZDwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 23:52:05 -0400
Received: from mail.perches.com ([173.55.12.10]:2057 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991Ab1EZDwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 23:52:03 -0400
Subject: Re: [PATCH] crypto: sha1: modify sha1_update to use SHA1_BLOCK_SIZE
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: msb@chromium.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org
In-Reply-To: <20110525.233411.1372538972166578285.davem@davemloft.net>
References: <1306379477-24552-1-git-send-email-msb@chromium.org>
	 <20110525.233411.1372538972166578285.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 20:52:01 -0700
Message-ID: <1306381921.28839.17.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 23:34 -0400, David Miller wrote:
> From: Mandeep Singh Baines <msb@chromium.org>
> Date: Wed, 25 May 2011 20:11:17 -0700
> > Plus some other minor cleanup.
> > Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> The temp[] buffer is explicitly places inside the inner most
> basic block so that the compiler doesn't allocate the stack
> space unless that code path is taken.

Does any version of gcc manage to do that?

Regardless, it's still a good idea to keep
declarations in the use scope.


