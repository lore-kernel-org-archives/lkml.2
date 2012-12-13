Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab2LMDG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 22:06:29 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:44942 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2LMDG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 22:06:27 -0500
Date: Thu, 13 Dec 2012 11:06:02 +0800
From: Adam Lee <adam8157@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 4/5] ktest: Fix breakage from change of oldnoconfig to
 olddefconfig
Message-ID: <20121213030602.GA10129@adam-station.nay.redhat.com>
References: <20121212221437.245229327@goodmis.org>
 <20121212221544.350555692@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212221544.350555692@goodmis.org>
X-PGP-Key-ID: 2F39D84D
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 05:14:41PM -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Commit fb16d891 "kconfig: replace 'oldnoconfig' with 'olddefconfig', and
> keep the old name", changed ktest's default config update from
> oldnoconfig to olddefconfig without adding oldnoconfig as a backup.
> The make oldnoconfig works much better than its backup of:
>    yes '' | make oldconfig
> 
> But due to this change, and the fact that ktest is used to build lots of
> older kernels (and for bisects), it forgoes the oldnoconfig completely.
> 
> Cc: Adam Lee <adam8157@gmail.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

This makes sense, we should provide a backup for older kernels. Sorry
for not noticing the breakage.

Acked-by: Adam Lee <adam8157@gmail.com>

-- 
Regards,
Adam Lee
http://adam8157.info
