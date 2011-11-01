Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1KAWZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 18:25:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37843 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab1KAWZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 18:25:30 -0400
MIME-Version: 1.0
Message-ID: <82d2f082-6ab1-479e-bbf9-f04992804420@default>
Date: Tue, 1 Nov 2011 15:25:14 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: RE: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
 <20111031171321.097a166c.kamezawa.hiroyu@jp.fujitsu.com>
 <ef778e79-72d0-4c58-99e8-3b36d85fa30d@default>
 <20111101095038.30289914.kamezawa.hiroyu@jp.fujitsu.com>
 <f62e02cd-fa41-44e8-8090-efe2ef052f64@default
 20111101144309.a51c99b5.akpm@linux-foundation.org>
In-Reply-To: <20111101144309.a51c99b5.akpm@linux-foundation.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EB071CF.0055,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
> 
> On Tue, 1 Nov 2011 08:25:38 -0700 (PDT)
> Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> At kernel summit there was discussion and overall agreement that we've
> been paying insufficient attention to the big-picture "should we
> include this feature at all" issues.  We resolved to look more
> intensely and critically at new features with a view to deciding
> whether their usefulness justified their maintenance burden.  It seems
> that you're our crash-test dummy ;) (Now I'm wondering how to get
> "cgroups: add a task counter subsystem" put through the same wringer).
> 
> I will confess to and apologise for dropping the ball on cleancache and
> frontswap.  I was never really able to convince myself that it met the
> (very vague) cost/benefit test, but nor was I able to present
> convincing arguments that it failed that test.  So I very badly went
> into hiding, to wait and see what happened.  What we needed all those
> months ago was to have the discussion we're having now.
> 
> This is a difficult discussion and a difficult decision.  But it is
> important that we get it right.  Thanks for you patience.

Thanks very much for your very kind response.  Let me know if
I can do anything else to help the process other than continuing
the discussion of course.  I'll be happy to help as soon as
I return from the crash-test-dummy hospital ;-)

Dan
