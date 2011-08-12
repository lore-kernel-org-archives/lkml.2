Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1HLMtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 08:49:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57197 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1HLMtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 08:49:22 -0400
MIME-Version: 1.0
In-Reply-To: <1313153166.6576.36.camel@twins>
References: <1313153166.6576.36.camel@twins>
Date: Fri, 12 Aug 2011 13:49:20 +0100
Message-ID: <CABcS5h2UEzUZ4a3F6Z8SAyn_3uzPDJ5FEpGnZVJ2ikKzeLd3Ew@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.0.1-rt9
From: Rolando Martins <rolando.martins@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great work!
Any news on the CGROUP_RT front?

Thanks,
Rolando

On Fri, Aug 12, 2011 at 1:46 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Yay!! another -rt kernel..
>
>
> Changes include:
>
>  - fixes so that PREEMPT_LL and PREEMPT_RTB kernels actually build
>   and boot, thanks to Tim Sanders for persisting on that.
>  - removed the removal of the export of of_find_property, spotted by Uwe
>  - added a few more patches that mostly clean up migrate_disable()
>   and pagefault_disable() bits.
>
>
> The patch is at:
>
>  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0.1-rt9.patch.bz2
>
> The quilt series can be found here:
>
>  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt9.tar.bz2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
