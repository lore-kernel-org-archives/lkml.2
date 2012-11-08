Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2KHOWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:22:50 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:45020 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab2KHOWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:22:49 -0500
Message-ID: <509BC026.4040209@gmail.com>
Date: Thu, 08 Nov 2012 22:22:30 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: jesse@nicira.com, dev@openvswitch.org, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/9] net: openvswitch: use this_cpu_ptr per-cpu helper
References: <5093EE59.8010609@gmail.com> <0000013ac23ac528-19a0dd1b-3144-45df-9d6e-471999d6ae31-000000@email.amazonses.com>
In-Reply-To: <0000013ac23ac528-19a0dd1b-3144-45df-9d6e-471999d6ae31-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter said, at 2012/11/3 1:46:
>>  		u64_stats_update_begin(&stats->sync);
>>  		stats->tx_packets++;
> 
> Use this_cpu_inc(vport->percpu_stats->packets) here?
 
Lots of network drivers use u64_stats_sync infrastructure for statistics
on 32bit or 64bit hosts no matter how many members in per-cpu variable. 

keep them be consistent, so no plan to change them.

Thanks 

