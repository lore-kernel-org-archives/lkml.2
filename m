Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab2KHRTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:19:00 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:45118 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779Ab2KHRS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:18:59 -0500
Date: Thu, 8 Nov 2012 17:18:55 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: jesse@nicira.com, dev@openvswitch.org, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/9] net: openvswitch: use this_cpu_ptr per-cpu helper
In-Reply-To: <509BC026.4040209@gmail.com>
Message-ID: <0000013ae10817d9-c5215352-348f-4898-b618-bb89e8725ab1-000000@email.amazonses.com>
References: <5093EE59.8010609@gmail.com> <0000013ac23ac528-19a0dd1b-3144-45df-9d6e-471999d6ae31-000000@email.amazonses.com> <509BC026.4040209@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2012, Shan Wei wrote:

> Christoph Lameter said, at 2012/11/3 1:46:
> >>  		u64_stats_update_begin(&stats->sync);
> >>  		stats->tx_packets++;
> >
> > Use this_cpu_inc(vport->percpu_stats->packets) here?
>
> Lots of network drivers use u64_stats_sync infrastructure for statistics

So they would all have an advantage from the patch.

