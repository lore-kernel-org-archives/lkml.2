Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab2BHKkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 05:40:08 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab2BHKkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 05:40:06 -0500
Message-ID: <4F325103.4000908@nod.at>
Date: Wed, 08 Feb 2012 11:40:03 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        jengelh@medozas.de, rostedt@goodmis.org
Subject: Re: [PATCH 4/4] Netfilter: xt_LOG: Implement ring buffer support
References: <1328400892-22409-1-git-send-email-richard@nod.at> <1328400892-22409-7-git-send-email-richard@nod.at> <20120208102914.GA32092@1984>
In-Reply-To: <20120208102914.GA32092@1984>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.02.2012 11:29, Pablo Neira Ayuso wrote:
> On Sun, Feb 05, 2012 at 01:14:52AM +0100, Richard Weinberger wrote:
>> This patch introduces NETFILTER_XT_TARGET_LOG_RING.
>> It allows logging into various ring buffers which are
>> represented as pipe-like files in /proc/net/netfilter/xt_LOG_ring/.
>>
>> Signed-off-by: Richard Weinberger<richard@nod.at>
>> ---
>>   include/linux/netfilter/xt_LOG.h    |   13 +-
>>   include/net/netfilter/nf_log.h      |    1 +
>>   include/net/netfilter/xt_log_ring.h |   24 +
>>   net/netfilter/Kconfig               |   13 +
>>   net/netfilter/Makefile              |    2 +
>>   net/netfilter/xt_LOG.c              |  921 -----------------------------
>>   net/netfilter/xt_LOG_core.c         | 1108 +++++++++++++++++++++++++++++++++++
>>   net/netfilter/xt_LOG_ring.c         |  430 ++++++++++++++
>
> Can you avoid this rename and splitting LOG into two files? I prefer
> having everything into the same file xt_LOG.c.

Sure, I'll merge it into one file.

I made the split to keep xt_LOG_core.c clean.
99% of xt_LOG_ring.c has nothing to do with netfilter and is just
ring_buffer and proc stuff.

> Apart from that, this looks fine to me.

:-)

Thanks,
//richard
