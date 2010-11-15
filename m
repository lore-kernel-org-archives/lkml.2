Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab0KOEmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 23:42:18 -0500
Received: from [120.204.251.227] ([120.204.251.227]:41884 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757396Ab0KOEmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 23:42:17 -0500
Message-ID: <4CE0BA03.5080409@leadcoretech.com>
Date: Mon, 15 Nov 2010 12:41:39 +0800
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; zh-CN; rv:1.9.2.12) Gecko/20101028 Lightning/1.0b2 Lanikai/3.1.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
CC: figo zhang <figo1802@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] Revert oom rewrite series
References: <20101114133543.E00A.A69D9226@jp.fujitsu.com>	<AANLkTikSq-qC28uurd17RGup92Kao7enCiGJkDnJG+94@mail.gmail.com>	<20101115093410.BEFD.A69D9226@jp.fujitsu.com>	<20101114181905.bc5b44f9.akpm@linux-foundation.org> <AANLkTik_SDaiu2eQsJ9+4ywLR5K5V1Od-hwop6gwas3F@mail.gmail.com>
In-Reply-To: <AANLkTik_SDaiu2eQsJ9+4ywLR5K5V1Od-hwop6gwas3F@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Nov 2010 04:42:12.0512 (UTC) FILETIME=[785ACA00:01CB847F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >Nothing to say, really.  Seems each time we're told about a bug or a
 >regression, David either fixes the bug or points out why it wasn't a
 >bug or why it wasn't a regression or how it was a deliberate behaviour
 >change for the better.

 >I just haven't seen any solid reason to be concerned about the state of
 >the current oom-killer, sorry.

 >I'm concerned that you're concerned!  A lot.  When someone such as
 >yourself is unhappy with part of MM then I sit up and pay attention.
 >But after all this time I simply don't understand the technical issues
 >which you're seeing here.

we just talk about oom-killer technical issues.

i am doubt that a new rewrite but the athor canot provide some evidence
and experiment result, why did you do that? what is the prominent change

for your new algorithm?

as KOSAKI Motohiro said, "you removed CAP_SYS_RESOURCE condition with
ZERO explanation".

David just said that pls use userspace tunable for protection by
oom_score_adj. but may i ask question:


1. what is your innovation for your new algorithm, the old one have the
same way for user tunable oom_adj.

2. if server like db-server/financial-server have huge import processes
(such as root/hardware access processes)want to be protection, you let

the administrator to find out which processes should be protection. you
will let the  financial-server administrator huge crazy!! and lose so
many money!! ^~^

3. i see your email in LKML, you just said
"I have repeatedly said that the oom killer no longer kills KDE when run

on my desktop in the presence of a memory hogging task that was written
specifically to oom the machine."
http://thread.gmane.org/gmane.linux.kernel.mm/48998


so you just test your new oom_killer algorithm on your desktop with KDE,
so have you provide the detail how you do the test? is it do the
experiment again for anyone and got the same result as your comment ?


as KOSAKI Motohiro said, in reality word, it we makes 5-6 brain
simulation, embedded, desktop, web server,db server, hpc, finance.
Different workloads certenally makes big impact. have you do those
experiments?


i think that technology should base on experiment not on imagine.


Best,
Figo.zhang
