Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1E1Th5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 15:37:57 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44562 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab1E1Thx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 15:37:53 -0400
Subject: Re: [PATCH V7 1/4 net-next] sock.h: Add a new sock zero-copy flag
From: Shirley Ma <mashirle@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1306610157.5180.80.camel@localhost.localdomain>
References: <1306610157.5180.80.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 May 2011 12:37:47 -0700
Message-ID: <1306611467.5180.98.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-28 at 12:15 -0700, Shirley Ma wrote:
> include/net/sock.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index f2046e4..2229bd1 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -563,6 +563,7 @@ enum sock_flags {
>  	SOCK_TIMESTAMPING_SYS_HARDWARE, /* %SOF_TIMESTAMPING_SYS_HARDWARE */
>  	SOCK_FASYNC, /* fasync() active */
>  	SOCK_RXQ_OVFL,
> +	SOCK_ZEROCOPY, /* buffers from userspace */
>  };
> 
>  static inline void sock_copy_flags(struct sock *nsk, struct sock *osk)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Forgot about this:

Signed-off-by: Shirley Ma <xma@us.ibm.com>
---

