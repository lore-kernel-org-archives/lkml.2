Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab0KAPiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:38:02 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54539 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab0KAPiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YUg7SVg1xqcGTFNIqPaap0+e+EKO1wHN1n/Gy7Kv8zxuta0OHtPV7NpLYyF0Ci0N95
         SPjPlSsbIMnB1ZRkcSj6BppC47wuP+DZRX4nqTf3CkZ2fqQNF7ZXFsoAJrTaW/VCtzeO
         HfHJuwvefOEbfQmpSDeLl4gjHg6TR/3A2pIQg=
Date: Mon, 1 Nov 2010 18:37:55 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: using smp_processor_id() in preemptible
	arch_trigger_all_cpu_backtrace_handler
Message-ID: <20101101153755.GB5985@lenovo>
References: <4CCEB51C.7010901@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCEB51C.7010901@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 01:39:56PM +0100, Jan Kiszka wrote:
> Hi,
> 
> I was getting this BUG while running into a GPF:
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: qemu-system-x86/2248
> caller is arch_trigger_all_cpu_backtrace_handler+0x1d/0xf7
> Pid: 2248, comm: qemu-system-x86 Not tainted 2.6.36+ #12
> Call Trace:
> [<ffffffff81203194>] debug_smp_processor_id+0xd8/0xf4
> [<ffffffff813803ab>] arch_trigger_all_cpu_backtrace_handler+0x1d/0xf7
...

 Thanks for report Jan. I'll take a look as only get ability.

 Cyrill
