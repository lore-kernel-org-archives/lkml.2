Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab0JTGCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:02:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab0JTGC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:02:29 -0400
Message-ID: <4CBE86E0.3050505@redhat.com>
Date: Wed, 20 Oct 2010 14:06:24 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] sysctl: remove sysctl syscall
References: <1287476560-5874-1-git-send-email-amwang@redhat.com>	<1287476560-5874-2-git-send-email-amwang@redhat.com>	<4CBD9B7F.6040307@linux.intel.com> <m1vd4yi977.fsf@fess.ebiederm.org>	<4CBDB385.6080100@linux.intel.com> <m1eibmdvew.fsf@fess.ebiederm.org>
In-Reply-To: <m1eibmdvew.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/10 00:00, Eric W. Biederman wrote:
> To the best of my knowledge the last and user of sys_sysctl is the glibc
> ioperm (my apologies I mispoke when I said iopl) implementation on arm.
> Not that people run around calling ioperm very often in any distro.


I saw that in Changelog of glibc too, but that was back to 2000, 10 years
past, I don't see any code using sysctl() in glibc now, except sys_sysctl()
itself, of course.

>
> All of that said I think disabling sys_sysctl by default now is totally
> reasonable.  If there is a percentage in removing the code we can worry
> about that later.  Perhaps we should add a CONFIG_CRUFT and move
> sys_sysctl under there.  Binary compatibility that nothing needs but
> that we actually have code for just in case.

But you put sysctl in features-removal-schedule.txt 3 years ago. :)

I believe they should see the kernel warnings if they are still using
sysctl.

Thanks.
