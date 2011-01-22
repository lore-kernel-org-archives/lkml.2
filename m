Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab1AVO0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 09:26:42 -0500
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:44046 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753197Ab1AVO0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 09:26:41 -0500
X-Greylist: delayed 1152 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Jan 2011 09:26:41 EST
X-Panda: scanned!
X-Spam-Summary: 2,-1.05263,0,b85536f2dd368688,d41d8cd98f00b204,rostedt@goodmis.org,tglx@linutronix.de:laijs@cn.fujitsu.com:mingo@elte.hu:a.p.zijlstra@chello.nl:akpm@linux-foundation.org:hidave.darkstar@gmail.com:dvhart@linux.intel.com:namhyung@gmail.com:linux-kernel@vger.kernel.org:torvalds@linux-foundation.org,RULES_HIT:152:355:379:599:601:945:960:988:989:1260:1261:1277:1311:1313:1314:1345:1358:1359:1437:1515:1516:1518:1534:1537:1567:1593:1594:1676:1711:1714:1730:1747:1766:1792:2393:2553:2559:2562:3027:3138:3867:3868:3870:3872:3873:5007:6117:7652:7875:7903:10004:10016:10400:10471,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:none,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Filterd-Recvd-Size: 1929
X-User-Agent: K-9 Mail for Android
References: <4D07330A.7020600@cn.fujitsu.com> <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6> <4D083900.1050801@cn.fujitsu.com> <1292386606.5015.1862.camel@gandalf.stny.rr.com> <4D130D23.1040309@cn.fujitsu.com> <1294851790.26623.372.camel@gandalf.stny.rr.com> <1294851864.26623.373.camel@gandalf.stny.rr.com> <1294851934.26623.374.camel@gandalf.stny.rr.com> <4D3012D5.4060709@cn.fujitsu.com> <alpine.LFD.2.00.1101211833120.2971@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1101211833120.2971@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V4] rtmutex: ensure only the top waiter or higher priority task can take the lock and remove unrelated boosting
From: Steven Rostedt <rostedt@goodmis.org>
Date: Sat, 22 Jan 2011 09:07:22 -0500
To: Thomas Gleixner <tglx@linutronix.de>, Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <5987f58c-029d-4b2d-a887-9589dcc4ae0c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Thomas Gleixner" <tglx@linutronix.de> wrote:

>On Fri, 14 Jan 2011, Lai Jiangshan wrote:
>> On 01/13/2011 01:05 AM, Steven Rostedt wrote:
>
>Does not apply to mainline. Can you please redo ?
>
>Thanks,
>
>	tglx

I'll see if I can pull it in and fix it.

-- Steve 

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
