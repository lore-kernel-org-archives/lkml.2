Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab1JNQBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:01:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1JNQBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:01:17 -0400
Date: Fri, 14 Oct 2011 20:01:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        lennart@poettering.net, harald@redhat.com, david@fubar.dk,
        greg@kroah.com, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Oleg Nesterov <oleg@redhat.com>, Paul Menage <paul@paulmenage.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?= =?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111014160110.GS14464@moon>
References: <1317943022.1095.25.camel@mop>
 <20111011161600.6145aa6b.akpm@linux-foundation.org>
 <20111012005935.GD14968@somewhere>
 <20111012174014.GE6281@google.com>
 <20111012181641.GZ15413@moon>
 <20111014153844.GP14968@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014153844.GP14968@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 05:38:47PM +0200, Frederic Weisbecker wrote:
...
> 
> Well, wouldn't it be better to pull that complexity to userspace?
> After all, moving tasks from a cgroup to another is not a performance
> critical operation so that probably doesn't need to be all handled by
> the kernel.
> 
> If one worries about concurrent clone/fork while moving tasks, then
> freezing the cgroup and moving its tasks away from userspace could
> be enough?

Well, it's not that problem to make it task-by-task, still I think
it's just a convenient shortcut :)

	Cyrill
