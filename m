Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab0KQX1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:27:07 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37452 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab0KQX1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:27:04 -0500
Message-ID: <4CE46443.2000002@oracle.com>
Date: Wed, 17 Nov 2010 15:24:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for November 17
References: <20101117140956.a8264c75.sfr@canb.auug.org.au>	<AANLkTinBiGOPptOY18-D+=djKLsJj75mXxL6ht6xNJXL@mail.gmail.com>	<20101117095920.2b9e2e6a.randy.dunlap@oracle.com> <20101118101459.472d540b.sfr@canb.auug.org.au>
In-Reply-To: <20101118101459.472d540b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/10 15:14, Stephen Rothwell wrote:
> On Wed, 17 Nov 2010 09:59:20 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>> Why was #include <linux/smp_lock.h> removed from <linux/hardirq.h> ?
>>
>> I added #include <linux/smp_lock.h> to i387.h, but them mm/filemap.c build fails
>> with the same error:
>>
>> linux-next-20101117/mm/filemap.c: In function 'iov_iter_copy_from_user_atomic':
>> linux-next-20101117/mm/filemap.c:1936: error: implicit declaration of function 'kernel_locked'
> 
> Was this fixed before Linus took that patch?  Also, the #include of

This build error was in linux-next of NOV. 17.  What mainline base did it use?
I don't exactly know how to answer your question...


> linux/smp_lock.h in linux/hardirq.h was the only line between #ifdef
> CONFIG_PREEMPT and #endif ... was this patch even reviewed?
> 
> Maybe (after it was reviewed) it should have been given more time in
> linux-next before being merged.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
