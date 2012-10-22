Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2JVT6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:58:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2JVT6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:58:40 -0400
Date: Mon, 22 Oct 2012 12:58:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, Jiri Slaby <jslaby@suse.cz>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 0/4] Rebase device_cgroup v2 patchset
Message-Id: <20121022125838.20cdc240.akpm@linux-foundation.org>
In-Reply-To: <20121022134536.172969567@napanee.usersys.redhat.com>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012 09:45:36 -0400
Aristeu Rozanski <aris@redhat.com> wrote:

> This patchset rebases the v2 of the patchset since the v1 was pushed into -rc1
> instead. The last patch, not present on previous patchset, fixes the
> permission check when allowing everything in a cgroup.
> 

I grabbed all four, thanks.  Shall send them on to Linus in a week or
so, after a bit more review and some linux-next testing.

I've been trying to work out why I merged the v1 patchset rather than
v2 and cannot find that v2 patchset anywhere.  When was it sent out?

