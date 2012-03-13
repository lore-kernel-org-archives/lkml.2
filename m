Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab2CMQbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:31:11 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52288 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755015Ab2CMQbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:31:09 -0400
MIME-Version: 1.0
X-Originating-IP: [24.106.62.130]
In-Reply-To: <CAGAVQTGus7LUWV3AdhAFy--gr=uJRWtSGjuP69-EckBiXy0qVg@mail.gmail.com>
References: <20120221211938.GE12236@google.com> <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins> <20120312222817.GI23255@google.com>
 <1331591568.18960.61.camel@twins> <20120312223944.GJ23255@google.com>
 <1331592241.18960.64.camel@twins> <20120312230416.GM23255@google.com>
 <20120313141032.GD29169@redhat.com> <CAGAVQTGus7LUWV3AdhAFy--gr=uJRWtSGjuP69-EckBiXy0qVg@mail.gmail.com>
From: C Anthony Risinger <anthony@xtfx.me>
Date: Tue, 13 Mar 2012 11:30:46 -0500
Message-ID: <CAGAVQTG_jUi3PffWQHc9jR6wA9gsEUXMMvb4LiimbpUZaxdGcw@mail.gmail.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Michal Schmidt <mschmidt@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 11:11 AM, C Anthony Risinger <anthony@xtfx.me> wrote:
>
> # what controllers are available for this process?
> $ cat /proc/self/tags/TYPE
^^^^^ should list of controllers either assigned to TYPE or not masked by MASK

> # explicit assign `users` 50 shares
> $ echo 50 > /proc/self/tags/admin.cpuacct.cpu.shares
                                               ^^^^^ s,admin,users,

> # `name`'s priority relative to sibling `name` groups (like shares)
> $ echo 100 > /proc/self/tags/admin.cpuacct.cpu.PRIORITY
^^^^^ maybe redundant, my original reasoning for it escapes me, but
could be useful for controllers that accept multiple `name`s

-- 

C Anthony
