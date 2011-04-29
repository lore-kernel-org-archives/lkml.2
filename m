Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab1D2KBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 06:01:16 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:40474 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1D2KBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 06:01:14 -0400
Subject: Re: [PATCH] s390, net: convert into new cpumask api
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ursula.braun@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20110429000104.3D5D.A69D9226@jp.fujitsu.com>
References: <20110429000104.3D5D.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 12:01:06 +0200
Message-ID: <1304071266.3171.3.camel@braunu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 23:59 +0900, KOSAKI Motohiro wrote:
> Adapt new api.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Ursula Braun <ursula.braun@de.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux390@de.ibm.com
> Cc: linux-s390@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
>  net/iucv/iucv.c |   70 +++++++++++++++++++++++++++---------------------------
>  1 files changed, 35 insertions(+), 35 deletions(-)
> 
> diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
> index 8f156bd..79f2caf 100644
> --- a/net/iucv/iucv.c
> +++ b/net/iucv/iucv.c
> @@ -128,8 +128,8 @@ struct iucv_irq_list {
>  };
> 
>  static struct iucv_irq_data *iucv_irq_data[NR_CPUS];
> -static cpumask_t iucv_buffer_cpumask = CPU_MASK_NONE;
> -static cpumask_t iucv_irq_cpumask = CPU_MASK_NONE;
> +static cpumask_t iucv_buffer_cpumask = { CPU_BITS_NONE };
> +static cpumask_t iucv_irq_cpumask = { CPU_BITS_NONE };
...
Applied and merged to our tree.
Thanks!


