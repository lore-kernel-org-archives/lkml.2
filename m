Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430Ab0KRQaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:30:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53579 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab0KRQaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:30:16 -0500
Message-ID: <4CE55445.8040002@oracle.com>
Date: Thu, 18 Nov 2010 08:28:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [build failure] Re: BKL: remove extraneous #include <smp_lock.h>
References: <201011172159.oAHLx1tu001236@hera.kernel.org> <20101117140526.d532b373.randy.dunlap@oracle.com> <AANLkTimO6CN9wOQco_1bqRmwBS7KfWW1CvumKFuiOWGH@mail.gmail.com> <20101118094342.GA10382@elte.hu> <AANLkTi=Xoo90jiaQBMxchFkKXt0dgre0tWe-LnVR6aSD@mail.gmail.com> <AANLkTikV+KVmwKg4jS2KPG+9EFdd9qD-VUak4qOgFgr4@mail.gmail.com>
In-Reply-To: <AANLkTikV+KVmwKg4jS2KPG+9EFdd9qD-VUak4qOgFgr4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/10 08:02, Linus Torvalds wrote:
> On Thu, Nov 18, 2010 at 7:57 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> How painful would it be to move lock_depth into thread_struct? I guess
>> we don't have anything that cares about structure offsets in assembly
>> for that thing.  I should just try.
> 
> Gaah, the only generic field there is the restart_block, so we'd have
> to hide it there, or then add it to each architecture. So scratch
> that.
> 
> I guess this is the simplest approach.

Yes, that builds.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


-- 
~Randy
