Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab2AUBYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 20:24:14 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35075 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752301Ab2AUBYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 20:24:12 -0500
Message-ID: <1327109035.1921.1.camel@joe2Laptop>
Subject: Re: [PATCH/RESEND] [trivial] sctp : Fix typo in net/sctp/socket.c
From: Joe Perches <joe@perches.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Date: Fri, 20 Jan 2012 17:23:55 -0800
In-Reply-To: <1327108681-1682-1-git-send-email-standby24x7@gmail.com>
References: <1327108681-1682-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-21 at 10:18 +0900, Masanari Iida wrote:
> Signed-off-by: Masanari Iida<standby24x7@gmail.com>
> 
> Correct a typo "sctp_setsocktopt_bindx" to "sctp_setsockopt_bindx"
> in net/sctp/socket.c
> ---
>  net/sctp/socket.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 408ebd0..658483e 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -970,7 +970,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(struct sock* sk,
>  	void *addr_buf;
>  	struct sctp_af *af;
>  
> -	SCTP_DEBUG_PRINTK("sctp_setsocktopt_bindx: sk %p addrs %p"
> +	SCTP_DEBUG_PRINTK("sctp_setsockopt_bindx: sk %p addrs %p"
>  			  " addrs_size %d opt %d\n", sk, addrs, addrs_size, op);

Let the compiler do it.

	SCTP_DEBUG_PRINTK("%s: sk %p addrs %p addrs_size %d opt %d\n",
			  __func__, sk, addrs, addrs_size, op);




