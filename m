Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422647Ab2KIBkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 20:40:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45086 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2KIBkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 20:40:04 -0500
Message-ID: <509C5EEE.4050205@gmail.com>
Date: Fri, 09 Nov 2012 09:39:58 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: jesse@nicira.com, dev@openvswitch.org, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/9] net: openvswitch: use this_cpu_ptr per-cpu helper
References: <5093EE59.8010609@gmail.com> <0000013ac23ac528-19a0dd1b-3144-45df-9d6e-471999d6ae31-000000@email.amazonses.com> <509BC026.4040209@gmail.com> <0000013ae10817d9-c5215352-348f-4898-b618-bb89e8725ab1-000000@email.amazonses.com>
In-Reply-To: <0000013ae10817d9-c5215352-348f-4898-b618-bb89e8725ab1-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter said, at 2012/11/9 1:18:
> On Thu, 8 Nov 2012, Shan Wei wrote:
> 
>> Christoph Lameter said, at 2012/11/3 1:46:
>>>>  		u64_stats_update_begin(&stats->sync);
>>>>  		stats->tx_packets++;
>>>
>>> Use this_cpu_inc(vport->percpu_stats->packets) here?
>>
>> Lots of network drivers use u64_stats_sync infrastructure for statistics
> 
> So they would all have an advantage from the patch.

I will try to do the optimizing next time in another patchset which not included
in this series patchset.

I will submit v3 version of this series after testing today.

Thanks

 
 

