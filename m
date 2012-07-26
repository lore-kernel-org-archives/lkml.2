Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab2GZOLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:11:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56291 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751226Ab2GZOLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:11:24 -0400
Message-ID: <1343311883.11398.21.camel@joe2Laptop>
Subject: Re: [PATCH]net:appletalk:ddp:fixed coding style issue in
 net/appletalk/ddp.c
From: Joe Perches <joe@perches.com>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: acme@ghostprotocols.net, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Jul 2012 07:11:23 -0700
In-Reply-To: <1343311142-4539-1-git-send-email-ahiliation@yahoo.co.in>
References: <1343311142-4539-1-git-send-email-ahiliation@yahoo.co.in>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 19:29 +0530, Jeffrin Jose wrote:
> Fixed coding style issue relating to switch  and case
> statement in file net/appletalk/ddp.c

Don't just move the case labels, move the code blocks
including comments.

> diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
[]
> @@ -1798,7 +1798,7 @@ static int atalk_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
>  
>  	switch (cmd) {
>  		/* Protocol layer */
> -		case TIOCOUTQ: {
> +	case TIOCOUTQ: {
>  			long amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);

		long amount = etc...

Post the patch with a commit message that says that
that a git diff -w is empty and the compiled objects
are the same too.


