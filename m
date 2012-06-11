Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2FKIh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:37:26 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:50956 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab2FKIhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:37:24 -0400
Subject: Re: [PATCH] crypto: s390 - clean up DES code a bit more
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1339194367.30984.18.camel@x61.thuisdomein>
References: <1339194367.30984.18.camel@x61.thuisdomein>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 11 Jun 2012 10:34:39 +0200
Message-ID: <1339403679.9116.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
x-cbid: 12061108-4966-0000-0000-00000295CA79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-09 at 00:26 +0200, Paul Bolle wrote:
> Commit 98971f8439b1bb9a61682fe24a865ddd25167a6b ("crypto: s390 - cleanup
> DES code") should have also removed crypto_des.h. That file is unused
> and unneeded since that commit. So let's clean up that file too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested. Ought to be correct.
> 
>  arch/s390/crypto/crypto_des.h |   18 ------------------
>  1 files changed, 0 insertions(+), 18 deletions(-)
>  delete mode 100644 arch/s390/crypto/crypto_des.h

Looks good!

Acked-by: Jan Glauber <jang@linux.vnet.ibm.com>

