Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1KDC4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:56:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54582 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab1KDC4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:56:01 -0400
Message-ID: <4EB3549D.5090404@cn.fujitsu.com>
Date: Fri, 04 Nov 2011 10:57:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tim Hockin <thockin@hockin.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com> <20111004150111.e9337268.akpm00@gmail.com> <CAAAKZwu67VMiZgdpp=i5p7zyGbOHGHXwF_iprufGPzTLkkUF2A@mail.gmail.com> <20111028163021.1ce61f8a.akpm@linux-foundation.org> <20111103170038.GG8198@somewhere.redhat.com>
In-Reply-To: <20111103170038.GG8198@somewhere.redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-04 10:55:54,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-04 10:55:58,
	Serialize complete at 2011-11-04 10:55:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> There may be other ways to cobble this sort of safety together, but
>>> they are less appealing for various reasons.  cgroups are how we
>>> control groups of related pids.
>>>
>>> I'd really love to be able to use this.
>>
>> Has it been confirmed that this implementation actually solves the
>> problem?  ie: tested a bit?
>>
>> btw, Frederic told me that this version of the patchset had some
>> serious problem so it's on hold pending an upgrade, regardless of other
>> matters.
> 
> Yep. The particular issue is https://lkml.org/lkml/2011/10/13/532
> 
> Li Zefan proposed a fix (https://lkml.org/lkml/2011/10/17/26) which I'm
> currently reworking.
> 

We really need to coordinate cgroup patches. I mean, the patchset+fix conflict
with Tejun's work, and the conflict is not trivial.

> But then I'd love it if you can test this subsystem to see if it really matches
> your needs, Tim.
> 
