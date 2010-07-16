Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935961Ab0GPIXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 04:23:38 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38424 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935944Ab0GPIXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 04:23:35 -0400
Message-ID: <4C4016FD.9080207@cs.helsinki.fi>
Date: Fri, 16 Jul 2010 11:23:25 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
References: <20100709190706.938177313@quilx.com> <alpine.DEB.2.00.1007141650110.29110@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1007141650110.29110@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Fri, 9 Jul 2010, Christoph Lameter wrote:
> 
>> The following patchset cleans some pieces up and then equips SLUB with
>> per cpu queues that work similar to SLABs queues.
> 
> Pekka, I think patches 4-8 could be applied to your tree now, they're 
> relatively unchanged from what's been posted before.  (I didn't ack patch 
> 9 because I think it makes slab_lock() -> slab_unlock() matching more 
> difficult with little win, but I don't feel strongly about it.)

Yup, I applied 4-8. Thanks guys!

> I'd also consider patch 7 for 2.6.35-rc6 (and -stable).

It's an obvious bug fix but is it triggered in practice? Is there a 
bugzilla report for that?
