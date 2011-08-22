Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab1HVBIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 21:08:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59449 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab1HVBIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 21:08:10 -0400
Message-ID: <4E51AC19.4010208@cn.fujitsu.com>
Date: Mon, 22 Aug 2011 09:08:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: rolando.martins@gmail.com
CC: containers@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: cpuset.sched_relax_domain_level problem
References: <CABcS5h13R0omxkZW_aJaza9FynbKSc=CVaYDkHMvJ64nAnWPvw@mail.gmail.com>
In-Reply-To: <CABcS5h13R0omxkZW_aJaza9FynbKSc=CVaYDkHMvJ64nAnWPvw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-22 09:07:07,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-22 09:07:09,
	Serialize complete at 2011-08-22 09:07:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Cc's

Rolando Martins wrote:
> Hi,
> I am testing kernel 3.0.3 and I am unable to "echo 3 >
> cpuset.sched_relax_domain_level".
> I was able to do it in 2.6.39.
> 
> Any clues?
> 

I think it's because your machine doesn't support level 3.

This commit made the change:

commit 60495e7760d8ee364695006af37309b0755e0e17
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Apr 7 14:10:04 2011 +0200

    sched: Dynamic sched_domain::level
    
    Remove the SD_LV_ enum and use dynamic level assignments.
