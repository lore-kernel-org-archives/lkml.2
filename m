Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab2KCE7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 00:59:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48077 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2KCE66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 00:58:58 -0400
Message-ID: <5094A485.4060409@gmail.com>
Date: Sat, 03 Nov 2012 12:58:45 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sven Eckelmann <sven@narfation.org>
CC: b.a.t.m.a.n@lists.open-mesh.org, lindner_marek@yahoo.de,
        siwu@hrz.tu-chemnitz.de, ordex@autistici.org,
        David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [B.A.T.M.A.N.] [PATCH v2 9/9] net: batman-adv: use per_cpu_add
 helper
References: <5093EE7E.6040400@gmail.com> <5905519.yWN2Ke3YlE@bentobox>
In-Reply-To: <5905519.yWN2Ke3YlE@bentobox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sven Eckelmann said, at 2012/11/3 1:55:
> On Saturday 03 November 2012 00:02:06 Shan Wei wrote:
>> From: Shan Wei <davidshan@tencent.com>
>>
>> As Christoph Lameter said:
>>> In addition, following usage of per_cpu_ptr can be replaced by
>>> this_cpu_read.
>>>
>>> cpu=get_cpu()
>>> ....
>>> *per_cpu_ptr(p,cpu)
>>> ....
>>> ....
>>> put_cpu()
>>
>> Right.
>>
>> Signed-off-by: Shan Wei <davidshan@tencent.com>
>> ---
> 
> Is this really supposed to be the commit message?

Maybe it's ok when Linus said this. :-)

Christoph is the maintainer of per-cpu.
So........

PER-CPU MEMORY ALLOCATOR
M:      Tejun Heo <tj@kernel.org>
M:      Christoph Lameter <cl@linux-foundation.org>
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git
S:      Maintained
F:      include/linux/percpu*.h
F:      mm/percpu*.c
F:      arch/*/include/asm/percpu.h

> 
> Kind regards,
> 	Sven
> 

