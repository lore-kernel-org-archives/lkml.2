Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1HZO6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:58:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55268 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab1HZO6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:58:37 -0400
MIME-Version: 1.0
In-Reply-To: <4E574B09.6050108@cn.fujitsu.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <20110801161900.1fe24b76.akpm@linux-foundation.org> <CAAAKZwupGmw_+EaApZFAqVcXWBF885Gsjx6tUWUdMuebXrt_Mg@mail.gmail.com>
 <CAPXgP11aUfdkq-SdaHc8=tfjA4W7DYXjSXG-asoZMi6hK4iOPQ@mail.gmail.com>
 <20110818143319.GC10441@somewhere> <CALdu-PA3+u-v1fj-DQuC-zyJ4Ud0Xi0sq0zcB0DLNcR_TMT6XQ@mail.gmail.com>
 <20110824175431.GA26417@somewhere.redhat.com> <4E574B09.6050108@cn.fujitsu.com>
From: Paul Menage <paul@paulmenage.org>
Date: Fri, 26 Aug 2011 07:58:16 -0700
X-Google-Sender-Auth: 3u3FNfT-LHm-bNMS3VRL34UK5OI
Message-ID: <CALdu-PD0EBK7YvxeuxVw5Z21JvfqbgiUoR5Wh3Of-FhG+VE3zg@mail.gmail.com>
Subject: Re: [RFD] Task counter: cgroup core feature or cgroup subsystem? (was
 Re: [PATCH 0/8 v3] cgroups: Task counter subsystem)
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 12:28 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> I had a patchset that can make things even better. The patchset is
> to bind/unbind a subsystem to/from an existing cgroup hierarchy.

Sigh, I'd been meaning to comment on that great patchset for ages, but
they kind of slipped out of my attention :-( I'll try to look over
them again - do they still apply cleanly after all the recent changes?

The bindability is orthogonal to the multi-subsystem support, I think
- they definitely complement each other.

Paul
