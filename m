Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab0D1Hkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 03:40:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52819 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0D1Hki convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:40:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kd1hizx35LBTuhA3c8W573KPmh3PzaqppXVRX3AU9RCNT4ETrNp+rO5kNQKvqIvE9B
         1cXJX9RdSGXuC4f9Cy1218z/7WXOPSMAxKx/fCw5pPeNSEFxUjvRxdEfc79g72gm8Mgb
         /A1Se2iqVr5AhwSGGKxpEdKyHlIvejkJLbZTs=
MIME-Version: 1.0
In-Reply-To: <201004272115.o3RLFnKj020353@imap1.linux-foundation.org>
References: <201004272115.o3RLFnKj020353@imap1.linux-foundation.org>
Date: Wed, 28 Apr 2010 09:40:36 +0200
Message-ID: <l2l81b0412b1004280040t415657c7qe7de59f152cd49aa@mail.gmail.com>
Subject: Re: [patch 1/1] sunrpc: use formatting of module name in SUNRPC
From: Alex Riesen <raa.lkml@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: trond.myklebust@fys.uio.no, linux-nfs@vger.kernel.org,
       Trond.Myklebust@netapp.com, cel@citi.umich.edu, davem@davemloft.net,
       tmtalpey@gmail.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 23:15,  <akpm@linux-foundation.org> wrote:
> From: Alex Riesen <raa.lkml@gmail.com>
>
> gcc-4.3.3 produces the warning:
>  "format not a string literal and no format arguments"
>
> Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> Cc: Chuck Lever <cel@citi.umich.edu>
> Cc: David S. Miller <davem@davemloft.net>
> Acked-by: Tom Talpey <tmtalpey@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  net/sunrpc/xprt.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>

This is one tough little patch... 2 years and counting...
