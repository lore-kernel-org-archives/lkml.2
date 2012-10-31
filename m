Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423181Ab2JaQXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:23:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56663 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935728Ab2JaQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:23:35 -0400
Date: Wed, 31 Oct 2012 09:23:30 -0700
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>, James Morris <jmorris@namei.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, Jiri Slaby <jslaby@suse.cz>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH] device_cgroup: fix unchecked cgroup parent usage
Message-ID: <20121031162330.GA2945@htj.dyndns.org>
References: <20121031160430.GD14789@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031160430.GD14789@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 12:04:30PM -0400, Aristeu Rozanski wrote:
> In 4cef7299b4786879a3e113e84084a72b24590c5b the cgroup parent usage is
> unchecked. root will not have a parent and trying to use
> device.{allow,deny} will cause problems. For some reason my stressing
> scripts didn't test the root directory so I didn't catch it on my
> regular tests.
> 
> Andrew, Tejun, this patch needs to make Linus tree ASAP or a revert for
> 4cef7299b4786879a3e113e84084a72b24590c5b.

 Acked-by: Tejun Heo <tj@kernel.org>

Andrew, can you please pick this one up?

Thanks.

-- 
tejun
