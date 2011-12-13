Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1LMP66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:58:58 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48498 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab1LMP6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:58:55 -0500
Date: Tue, 13 Dec 2011 07:58:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
Message-ID: <20111213155848.GI25802@google.com>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

Can you please rebase the patchset on top of cgroup/for-3.3?  I
primarily like the idea of being able to track process usage w/ cgroup
and enforce limits on it but hope that it could somehow integrate w/
cgroup freezer.  ie. trigger freezer if it goes over limit and let the
userland tool / administrator deal with the frozen cgroup.  I'm
planning on extending cgroup freezer such that it supports recursive
freezing and killing of frozen tasks.  If we can fit task counters
into that, we'll have general method of handling problematic cgroups -
freeze, notify userland and let it deal with it.

Thank you.

-- 
tejun
