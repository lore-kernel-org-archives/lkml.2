Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102Ab2KPIac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:30:32 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42822 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:30:31 -0500
Message-ID: <50A5F99D.8020503@gmail.com>
Date: Fri, 16 Nov 2012 16:30:21 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, David Miller <davem@davemloft.net>,
        paulmck@linux.vnet.ibm.com, rostedt@goodmis.org
CC: Christoph Lameter <cl@linux.com>, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9 v4] use efficient this_cpu_* helper
References: <50A1A7A9.6050501@gmail.com> <0000013b047079ab-01971b64-07e2-4f2e-a204-6baff2180fc3-000000@email.amazonses.com> <20121115145325.GC7306@mtj.dyndns.org>
In-Reply-To: <20121115145325.GC7306@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun Heo:

Tejun Heo said, at 2012/11/15 22:53:
> On Thu, Nov 15, 2012 at 02:19:38PM +0000, Christoph Lameter wrote:
>> Tejon: Could you pick up this patchset?
> 
> Sure, but, Shan, when posting patchset, please make the patches
> replies to the head message; otherwise, it's pretty difficult to track
> what's going on with the patchset as a whole.  I see that some patches
> are being picked up by respective subsystems.  If you have patches
> left, please let me know.

OK, next time i will do as you suggest.

This patchset include more subsystem, i.e network, rcu, trace.
The best way to avoid code conflict is subsystem maintainer to pick them up
to their code tree. I will remind them in each patch that not yet applied and 
add you to the receiver list.

Best Regards
Shan Wei

> 
> Thanks.
> 

