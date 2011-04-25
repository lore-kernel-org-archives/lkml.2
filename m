Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1DYHTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 03:19:38 -0400
Received: from trent.utfs.org ([194.246.123.103]:55728 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316Ab1DYHTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 03:19:37 -0400
Date: Mon, 25 Apr 2011 00:19:24 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <20110424234655.GC12436@dastard> <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011 at 09:46, Dave Chinner wrote:
> I'd say they are not being reclaimmmed because the VFS hasn't let go
> of them yet. Can you also dump /proc/sys/fs/{dentry,inode}-state so
> we can see if the VFS has released the inodes such that they can be
> reclaimed by XFS?

Please see http://nerdbynature.de/bits/2.6.39-rc4/oom/

 - slabinfo-4.txt.bz2, contains /proc/sys/fs/{dentry,inode}-state and
   /proc/fs/xfs/stat (is this interesting at all?) and a few other
   /proc outputs
 - messages-4.txt, contains the syslog from this run.

Should I enable a few more DEBUG_* options in the kernel? Which options 
would be helpful?

Thanks for looking into it,
Christian.
-- 
BOFH excuse #194:

We only support a 1200 bps connection.
