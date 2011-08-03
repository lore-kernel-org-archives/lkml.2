Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1HCVF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 17:05:29 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:36904 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab1HCVFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 17:05:24 -0400
Message-ID: <4E39B806.6020405@cs.tu-berlin.de>
Date: Wed, 03 Aug 2011 23:05:10 +0200
From: =?UTF-8?B?SmFuIFNjaMO2bmhlcnI=?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110508 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFCv2 0/8] sched: Enforce order of leaf CFS runqueues
 (and list cleanup)
References: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
In-Reply-To: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Am 27.07.2011 21:10, schrieb Jan H. Schönherr:
> Patch 1: After inventing __list_link(), I realized, that this
> 	 function already existed, but with a different name.
> 
> 	 This patch just does some renaming. Not really needed,
> 	 but if I use the old naming in patch 2 it's really 
> 	 hard to understand what's actually going on.
> 
> 	 It also helps to increase the readability of the existing
> 	 code, see patches 6-8.
> 
> Patch 2: This introduces new list functions to splice RCU lists
> 	 and handle deleted RCU list entries.
> 
> Patch 3: The actual bugfix.
> 
> Patch 4+5: Follow-ups to patch 1. Some more renaming and use of
> 	   appropriate functions.
> 
> Patch 6: Another follow-up to patch 1, improving the readability of
> 	 the list routines a bit.
> 
> Patch 7+8: Follow-ups to patch 2. Make use of the introduced
>            functionality in the already existing code.


I am wondering, whether v3 should consist basically only of
patches 2 and 3, i. e. the minimal approach, or if you would
take all of them?

If you prefer the minimal version, I would make another patch
set out of the other patches. But as there seems to be no official
maintainer for list related functionality, I would appreciate
some hints who I should put on the TO/CC list.

Regards
Jan
