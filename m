Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab0E0HV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 03:21:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:29450 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab0E0HVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 03:21:54 -0400
Message-ID: <4BFE1BD7.2090702@monstr.eu>
Date: Thu, 27 May 2010 09:14:31 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       michal.simek@petalogix.com, arnd@arndb.de, john.williams@petalogix.com,
       tglx@linutronix.de, peter.fritzsche@gmx.de, anton@samba.org,
       mingo@elte.hu
Subject: Re: [PATCH] asm-generic: Use raw_local_irq_save/restore instead local_irq_save/restore
References: <1274863724-14906-1-git-send-email-monstr@monstr.eu>	 <1274863724-14906-2-git-send-email-monstr@monstr.eu>	 <1274884963.22648.245.camel@gandalf.stny.rr.com>	 <20100526100805.171b3c48.akpm@linux-foundation.org> <1274893911.22648.246.camel@gandalf.stny.rr.com>
In-Reply-To: <1274893911.22648.246.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2010-05-26 at 10:08 -0700, Andrew Morton wrote:
> 
>> If a developer looks at atomic_add_return() and asks himself "why did
>> this use raw_local_irq_save()", the only way of answering that question
>> is to go groveling through the git logs, which is a right PITA if
>> you're trying to get some coding work done.
>>
>> Guys, any time you add code which is non-obvious at the raw C level, it
>> *needs* a comment!
> 
> Totally agree!  I've gotten pretty good at adding comments to changes
> like this that I do. I need to get better at telling others to comment
> their work ;-)

ok. Will add any sensible comment.

Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
