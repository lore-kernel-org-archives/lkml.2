Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab2FADIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 23:08:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758799Ab2FADIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 23:08:10 -0400
Message-ID: <4FC83277.2090301@redhat.com>
Date: Fri, 01 Jun 2012 11:09:43 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, edumazet@google.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [V2 PATCH] net: sock: validate data_len before allocating skb
 in sock_alloc_send_pskb()
References: <20120531071809.6392.26677.stgit@amd-6168-8-1.englab.nay.redhat.com> <20120531.182145.119572313886189417.davem@davemloft.net>
In-Reply-To: <20120531.182145.119572313886189417.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 06:21 AM, David Miller wrote:
> From: Jason Wang<jasowang@redhat.com>
> Date: Thu, 31 May 2012 15:18:10 +0800
>
>> We need to validate the number of pages consumed by data_len, otherwise frags
>> array could be overflowed by userspace. So this patch validate data_len and
>> return -EMSGSIZE when data_len may occupies more frags than MAX_SKB_FRAGS.
>>
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
> Applied and queued up for -stable.
>
> Please do not add explicit stable CC:'s to networking patches, I queue
> appropriate changes up myself, and submit them only when I feel that
> the change has had sufficient exposure and testing in Linus's tree.

Sure, would pay attention next time.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

