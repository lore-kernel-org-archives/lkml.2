Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab2KAJJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:09:10 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:62926 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2KAJJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:09:08 -0400
Message-ID: <50923C2F.6060200@gmail.com>
Date: Thu, 01 Nov 2012 17:09:03 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Christoph Lameter <cl@linux.com>, dipankar@in.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/9] rcu:  use this_cpu_ptr per-cpu helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
References: <50910A17.1090600@gmail.com> <0000013ab7eefc03-20a4ba94-f83f-4624-9dac-dfe3924277b4-000000@email.amazonses.com> <20121031200842.GC3027@linux.vnet.ibm.com>
In-Reply-To: <20121031200842.GC3027@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney said, at 2012/11/1 4:08:
> 
> One thing to keep in mind -- the only purpose of this is to diffuse
> memory contention.  So there is no need to disable preemption.

same question to me.
Christoph, maybe __this_cpu_read is a better choice which don't disable preemption.

> 
> 							Thanx, Paul
> 
> 

