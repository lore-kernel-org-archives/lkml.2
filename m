Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab2FGUjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:39:52 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:10233 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab2FGUjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:39:51 -0400
Message-ID: <4FD11194.2040405@hp.com>
Date: Thu, 07 Jun 2012 13:39:48 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>, jasowang@redhat.com,
        netdev@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [V2 RFC net-next PATCH 2/2] virtio_net: export more statistics
 through ethtool
References: <20120606075208.29081.75284.stgit@amd-6168-8-1.englab.nay.redhat.com> <20120606075217.29081.30713.stgit@amd-6168-8-1.englab.nay.redhat.com> <1339089306.2770.10.camel@bwh-desktop.uk.solarflarecom.com> <20120607.130512.219951433412203999.davem@davemloft.net> <1339100649.2770.20.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1339100649.2770.20.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 01:24 PM, Ben Hutchings wrote:
> On Thu, 2012-06-07 at 13:05 -0700, David Miller wrote:
>> From: Ben Hutchings<bhutchings@solarflare.com>
>> Date: Thu, 7 Jun 2012 18:15:06 +0100
>>
>>> I would really like to see some sort of convention for presenting
>>> per-queue statistics through ethtool.  At the moment we have a complete
>>> mess of different formats:
>>
>> Indeed.  Probably ${QUEUE_TYPE}-${INDEX}-${STATISTIC} is best.
>> With an agreed upon list of queue types such as "rx", "tx", "rxtx"
>> etc.
>
> I think we should leave the type names open-ended, as there are other
> useful groupings like per-virtual-port.  In that case the separator
> should be chosen to allow arbitrary type names without ambiguity.

So you mean like something along the lines of the presence of say '.' 
indicating indent a level:

rx_bytes:  1234
     myqueue1.rx_bytes: 234
     myqueue2.rx_bytes: 345
     ...

rick jones
