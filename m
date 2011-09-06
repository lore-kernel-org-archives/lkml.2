Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1IFJFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 05:05:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63883 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab1IFJFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 05:05:40 -0400
Message-ID: <4E65E284.50102@cn.fujitsu.com>
Date: Tue, 06 Sep 2011 17:06:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Paul Menage <paul@paulmenage.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFD] Task counter: cgroup core feature or cgroup subsystem?
 (was Re: [PATCH 0/8 v3] cgroups: Task counter subsystem)
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com> <20110801161900.1fe24b76.akpm@linux-foundation.org> <CAAAKZwupGmw_+EaApZFAqVcXWBF885Gsjx6tUWUdMuebXrt_Mg@mail.gmail.com> <CAPXgP11aUfdkq-SdaHc8=tfjA4W7DYXjSXG-asoZMi6hK4iOPQ@mail.gmail.com> <20110818143319.GC10441@somewhere> <CALdu-PA3+u-v1fj-DQuC-zyJ4Ud0Xi0sq0zcB0DLNcR_TMT6XQ@mail.gmail.com> <20110824175431.GA26417@somewhere.redhat.com> <4E574B09.6050108@cn.fujitsu.com> <CALdu-PD0EBK7YvxeuxVw5Z21JvfqbgiUoR5Wh3Of-FhG+VE3zg@mail.gmail.com>
In-Reply-To: <CALdu-PD0EBK7YvxeuxVw5Z21JvfqbgiUoR5Wh3Of-FhG+VE3zg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-06 17:04:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-06 17:04:27,
	Serialize complete at 2011-09-06 17:04:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

22:58, Paul Menage wrote:
> On Fri, Aug 26, 2011 at 12:28 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>> I had a patchset that can make things even better. The patchset is
>> to bind/unbind a subsystem to/from an existing cgroup hierarchy.
> 
> Sigh, I'd been meaning to comment on that great patchset for ages, but
> they kind of slipped out of my attention :-( I'll try to look over
> them again - do they still apply cleanly after all the recent changes?
> 

I was interrupted by other work at that time and didn't continue to push the
patchset after that. I'll rebase the patchset and send it out.

> The bindability is orthogonal to the multi-subsystem support, I think
> - they definitely complement each other.
> 
> Paul
> 
