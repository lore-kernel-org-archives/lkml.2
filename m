Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab1KGOY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:24:28 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:53587 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1KGOY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:24:26 -0500
Message-ID: <4EB7EA14.7000707@linux.vnet.ibm.com>
Date: Mon, 07 Nov 2011 19:54:20 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Feng King <kinwin2008@gmail.com>
CC: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Fix comments for Nagle algorithm
References: <1320503003-5169-1-git-send-email-kinwin2008@gmail.com>
In-Reply-To: <1320503003-5169-1-git-send-email-kinwin2008@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2011 07:53 PM, Feng King wrote:
> TCP_NODELAY is weaker than TCP_CORK, when TCP_CORK was set, small
> segments will always pass Nagle test regardless of TCP_NODELAY option.
> 
> Signed-off-by: Feng King <kinwin2008@gmail.com>
> 

You have missed adding "---" after the Signed-off-by line.
The tools that are used to extract the patch from the email will look
for that symbol to distinguish things.

[FYI, tools like git or stgit can generate your patches in the right
format automatically for you.]

Thanks,
Srivatsa S. Bhat

> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 882e0b0..a908f95 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1377,7 +1377,7 @@ static inline int tcp_minshall_check(const struct tcp_sock *tp)
>  /* Return 0, if packet can be sent now without violation Nagle's rules:
>   * 1. It is full sized.
>   * 2. Or it contains FIN. (already checked by caller)
> - * 3. Or TCP_NODELAY was set.
> + * 3. Or TCP_CORK is not set, and TCP_NODELAY is set.
>   * 4. Or TCP_CORK is not set, and all sent packets are ACKed.
>   *    With Minshall's modification: all sent small packets are ACKed.
>   */
