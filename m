Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab2JHMis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:38:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62426 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2JHMiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:38:46 -0400
Message-ID: <5072C953.9080207@gmail.com>
Date: Mon, 08 Oct 2012 08:38:43 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: sri@us.ibm.com, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sctp: Fix typo in socket.c
References: <1349448624-15060-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1349448624-15060-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 10:50 AM, Masanari Iida wrote:
> Correct spelling typo in net/sctp/socket.c
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

> ---
>   net/sctp/socket.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index d37d24f..aaeff63 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -973,7 +973,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(struct sock* sk,
>   	void *addr_buf;
>   	struct sctp_af *af;
>
> -	SCTP_DEBUG_PRINTK("sctp_setsocktopt_bindx: sk %p addrs %p"
> +	SCTP_DEBUG_PRINTK("sctp_setsockopt_bindx: sk %p addrs %p"
>   			  " addrs_size %d opt %d\n", sk, addrs, addrs_size, op);
>
>   	if (unlikely(addrs_size <= 0))
>

