Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0IGRaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 13:30:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:59244 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab0IGRaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 13:30:24 -0400
Message-ID: <4C8676AA.9030706@windriver.com>
Date: Tue, 07 Sep 2010 12:30:18 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Fix typos
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com> <20100902121853.e90f6c53.randy.dunlap@oracle.com>
In-Reply-To: <20100902121853.e90f6c53.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Sep 2010 17:30:19.0415 (UTC) FILETIME=[57C95A70:01CB4EB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 02:18 PM, Randy Dunlap wrote:
> On Thu, 2 Sep 2010 16:05:14 -0300 Lucas De Marchi wrote:
> 
>> Hi,
>>
>> I'd like to know if it's worth fixing all typos found in comments,
>> documentation and sometimes code. A first attempt to do that you can
>> find at http://people.profusion.mobi/~lucas/kernel-typos-fix.patch
>>
>> This was done by using the list of common typos available at
>> http://en.wikipedia.org/wiki/Wikipedia:Lists_of_common_misspellings
>>
>> I already removed some false positives, but there are more. Before
>> going ahead and verifying all of them, I'd like to know whether this
>> would be a good patch.
> 
> Hi,
> 
> I'd take most of the corrections in Documentation/, but in general,
> I don't think that it's a good idea without some careful review.

I am in agreement with Randy on his point that any changes should get
reviewed if possible by the people who own the files or authored the
comments.

I reviewed all the pieces that were kdb / kgdb related which include
the following and all the changes are ok (one exception noted).

Documentation/kernel-parameters.txt
arch/cris/arch-v32/kernel/kgdb.c
drivers/misc/kgdbts.c
kernel/debug/kdb/kdb_main.c
kernel/debug/kdb/kdb_support.c

--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -277,7 +277,7 @@ static int hw_break_release_slot(int breakno)
 		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
 		if (dbg_release_bp_slot(*pevent))
 			/*
-			 * The debugger is responisble for handing the retry on
+			 * The debugger is responsible for handing the retry on

---- from Jason ----

This should actually be:

+			 * The debugger is responsible for handling the retry on

--------------------

Thanks,
Jason.
