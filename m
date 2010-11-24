Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0KXRDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:03:30 -0500
Received: from build.ihdev.net ([178.63.197.118]:58093 "EHLO build.ossfans.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab0KXRD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:03:29 -0500
Date: Wed, 24 Nov 2010 12:03:26 -0500
From: Sergey Lapin <slapin@ossfans.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ldisc problems with 2.6.32-2.6.37-rc2 (at least)
Message-ID: <20101124170326.GB7282@build.ihdev.net>
References: <20101124135249.GA7282@build.ihdev.net>
 <4CED2251.3020708@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CED2251.3020708@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry, I was wrong.

> Hi, I don't think you get similar backtraces in .37-rc2. Could you grab one?

Yeah, they are different definitely.

------------[ cut here ]------------
WARNING: at drivers/tty/tty_ldisc.c:451 tty_ldisc_open+0x3c/0x9c()
Modules linked in:
[<c002c694>] (unwind_backtrace+0x0/0xe4) from [<c0037ad4>] (warn_slowpath_common+0x4c/0x64)
[<c0037ad4>] (warn_slowpath_common+0x4c/0x64) from [<c0037b04>] (warn_slowpath_null+0x18/0x1c)
[<c0037b04>] (warn_slowpath_null+0x18/0x1c) from [<c01bb88c>] (tty_ldisc_open+0x3c/0x9c)
[<c01bb88c>] (tty_ldisc_open+0x3c/0x9c) from [<c01bc110>] (tty_set_ldisc+0x328/0x454)
[<c01bc110>] (tty_set_ldisc+0x328/0x454) from [<c01b6624>] (tty_ioctl+0x83c/0xac4)
[<c01b6624>] (tty_ioctl+0x83c/0xac4) from [<c00b383c>] (vfs_ioctl+0x20/0x3c)
[<c00b383c>] (vfs_ioctl+0x20/0x3c) from [<c00b3f9c>] (do_vfs_ioctl+0x540/0x598)
[<c00b3f9c>] (do_vfs_ioctl+0x540/0x598) from [<c00b4028>] (sys_ioctl+0x34/0x54)
[<c00b4028>] (sys_ioctl+0x34/0x54) from [<c0027a80>] (ret_fast_syscall+0x0/0x2c)
---[ end trace 7979e0da5684d2cf ]---

All the best,
S.

