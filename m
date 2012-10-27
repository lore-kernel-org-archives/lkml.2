Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab2J0RHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 13:07:13 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59824 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2J0RHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 13:07:11 -0400
MIME-Version: 1.0
In-Reply-To: <1351349616-22974-1-git-send-email-standby24x7@gmail.com>
References: <1351349616-22974-1-git-send-email-standby24x7@gmail.com>
From: Mark Einon <mark.einon@gmail.com>
Date: Sat, 27 Oct 2012 18:06:54 +0100
Message-ID: <CANK3SE2BrcMAy1ikgHE7hX2k38qHfP6GqYY5XNJUMH3Zz3hLKQ@mail.gmail.com>
Subject: Re: [PATCH] staging: csr: Fix typo in csr/netdev.c
To: Masanari Iida <standby24x7@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 October 2012 15:53, Masanari Iida <standby24x7@gmail.com> wrote:
> Correct spelling typo in trace message.
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/staging/csr/netdev.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
> index 0e34020..878c3df 100644
> --- a/drivers/staging/csr/netdev.c
> +++ b/drivers/staging/csr/netdev.c
> @@ -100,7 +100,7 @@
>  #endif /* LINUX_VERSION_CODE */
>
>
> -/* Wext handler is suported only if CSR_SUPPORT_WEXT is defined */
> +/* Wext handler is supported only if CSR_SUPPORT_WEXT is defined */
>  #ifdef CSR_SUPPORT_WEXT
>  extern struct iw_handler_def unifi_iw_handler_def;
>  #endif /* CSR_SUPPORT_WEXT */
> @@ -146,7 +146,7 @@ typedef int (*tx_signal_handler)(unifi_priv_t *priv, struct sk_buff *skb, const
>  /*
>   * The driver uses the qdisc interface to buffer and control all
>   * outgoing traffic. We create a root qdisc, register our qdisc operations
> - * and later we create two subsiduary pfifo queues for the uncontrolled
> + * and later we create two subsidiary pfifo queues for the uncontrolled
>   * and controlled ports.
>   *
>   * The network stack delivers all outgoing packets in our enqueue handler.
> @@ -1748,7 +1748,7 @@ send_ma_pkt_request(unifi_priv_t *priv, struct sk_buff *skb, const struct ethhdr
>          return -1;
>      }
>
> -    /* RA adrress must contain the immediate destination MAC address that is similiar to
> +    /* RA adrress must contain the immediate destination MAC address that is similar to

Hi Masanari,

You've also missed the fact that 'address' is spelt incorrectly in
'RSA adrress' here.

Cheers,

Mark
