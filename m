Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934335Ab1KCRC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:02:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61105 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934243Ab1KCRC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:02:56 -0400
MIME-Version: 1.0
In-Reply-To: <4EB2C852.6020706@parallels.com>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <20111004150111.e9337268.akpm00@gmail.com> <CAAAKZwu67VMiZgdpp=i5p7zyGbOHGHXwF_iprufGPzTLkkUF2A@mail.gmail.com>
 <20111028163021.1ce61f8a.akpm@linux-foundation.org> <CAA6-i6o0SPfZJDx4SRR1hY-He0L6zHuv0saH6EaE7Mrc2HF6PA@mail.gmail.com>
 <20111103164917.GF8198@somewhere.redhat.com> <4EB2C852.6020706@parallels.com>
From: Paul Menage <paul@paulmenage.org>
Date: Thu, 3 Nov 2011 10:02:35 -0700
X-Google-Sender-Auth: XOwes9ZBs1THXupjwwxokhha-aY
Message-ID: <CALdu-PDY8zpXYM3V9KRk4f2NyGevfNnuaWVdoT-qzSHOK--K3A@mail.gmail.com>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
To: Glauber Costa <glommer@parallels.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Hockin <thockin@hockin.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 9:58 AM, Glauber Costa <glommer@parallels.com> wrote:
>
> Because you are controlling tasks, and tasks are the main building block of
> all cgroups, I think you should at least consider either using
> a cgroup property,

I don't see how making it a core cgroup property would remove the need
to walk the hierarchy.

Paul
