Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab0FIJj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:39:28 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46601 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab0FIJj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:39:26 -0400
Message-ID: <4C0F614D.7050808@fusionio.com>
Date: Wed, 09 Jun 2010 11:39:25 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Carl Worth <cworth@cworth.org>,
       Eric Anholt <eric@anholt.net>, Venkatesh Pallipadi <venki@google.com>,
       Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David H?rdeman <david@hardeman.nu>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.35-rc2-git2: Reported regressions from 2.6.34
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera> <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org> <4C0F4872.7090909@fusionio.com> <20100609093249.GA17026@elte.hu>
In-Reply-To: <20100609093249.GA17026@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-09 11:32, Ingo Molnar wrote:
>> This should be fixed by commit 28f4197e which was merged on friday.
> 
> The scheduler commit adding local_clock() (for .36) is:
> 
>   c676329: sched_clock: Add local_clock() API and improve documentation
> 
> So once that is upstream the block IO statistics code can use that.

Thanks, I'll have to make a note of that.

-- 
Jens Axboe

