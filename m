Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2HXW6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:58:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45010 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2HXW6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:58:44 -0400
Date: Fri, 24 Aug 2012 15:58:39 -0700
From: Tejun Heo <tj@kernel.org>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v7 0/4] cgroup: add xattr support
Message-ID: <20120824225839.GM21325@google.com>
References: <20120823205327.237533518@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823205327.237533518@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 23, 2012 at 04:53:27PM -0400, aris@redhat.com wrote:
> This series are a refreshed version of a patchset submitted by Li Zefan back
> in march:
> 	https://lkml.org/lkml/2012/3/1/13

Applied to cgroup/for-3.7 w/ "Original-Patch-by: Li Zefan" added for
the first three patches.

* Can you please update MTA setting so that the From: header contains
  your full name?  Importing the series to git ended up with
  "aris@redhat.com <aris@redhat.com>".

* Can you please add some comments and documentation regarding this?

Thanks.

-- 
tejun
