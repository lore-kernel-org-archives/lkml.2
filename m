Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2JVNpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674Ab2JVNpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:45:51 -0400
Message-Id: <20121022134536.172969567@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Mon, 22 Oct 2012 09:45:36 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, Jiri Slaby <jslaby@suse.cz>,
        cgroups@vger.kernel.org
Subject: [PATCH 0/4] Rebase device_cgroup v2 patchset
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset rebases the v2 of the patchset since the v1 was pushed into -rc1
instead. The last patch, not present on previous patchset, fixes the
permission check when allowing everything in a cgroup.

 device_cgroup.c |   87 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 61 insertions(+), 26 deletions(-)

Cc: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu
