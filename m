Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab2ECXdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:33:45 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64962 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756385Ab2ECXdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:33:44 -0400
MIME-Version: 1.0
In-Reply-To: <CABEgKgrkQ=asB2WExQb1KTd1MyoWDwJCO2_u2cJC4toEUa3C4g@mail.gmail.com>
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au>
	<4F9ABF9C.2070707@xenotime.net>
	<alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com>
	<20120427132343.fbb443b9.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com>
	<20120427143646.8209627e.akpm@linux-foundation.org>
	<87fwbnag6u.fsf@skywalker.in.ibm.com>
	<alpine.DEB.2.00.1205030208120.21476@chino.kir.corp.google.com>
	<CABEgKgqWo=b=o7PwOLc=QqCWXQxUaYvMX99GP9cR_Y-RoTEW3g@mail.gmail.com>
	<alpine.DEB.2.00.1205031343300.1631@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1205031454400.1631@chino.kir.corp.google.com>
	<CABEgKgrkQ=asB2WExQb1KTd1MyoWDwJCO2_u2cJC4toEUa3C4g@mail.gmail.com>
Date: Fri, 4 May 2012 08:33:43 +0900
Message-ID: <CABEgKgoPf69-Ps5Gc6Rv-TVVBxvTdjOJCdnbh6DzTa4A2m2y9A@mail.gmail.com>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 8:21 AM, Hiroyuki Kamezawa
<kamezawa.hiroyuki@gmail.com> wrote:
> On Fri, May 4, 2012 at 6:57 AM, David Rientjes <rientjes@google.com> wrote:
>> On Thu, 3 May 2012, David Rientjes wrote:
>> If I add XX:+UseLargePages to the command line to use
>> hugepages it's even larger.

Ah, sorry. I couldn't understand this. Why performance difference gets larger if
usage of anon memory decreases ? I guess overheads are just added to anon page
faults and file cache handling. If you use Hugepage, anon memory overheads will
disappear.

Thanks,
-Kame
