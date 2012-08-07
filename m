Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab2HGGkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 02:40:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38042 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2HGGj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 02:39:59 -0400
Date: Tue, 7 Aug 2012 07:39:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Kamal Mostafa <kamal@canonical.com>,
        "Peter M. Petrakis" <peter.petrakis@canonical.com>,
        Dann Frazier <dann.frazier@canonical.com>,
        Massimo Morana <massimo.morana@canonical.com>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org
Subject: Re: mq: INFO: possible circular locking dependency detected
Message-ID: <20120807063955.GX23464@ZenIV.linux.org.uk>
References: <501D0093.2090108@gmail.com>
 <20120805170856.GC8954@localhost>
 <20120807050412.GA23960@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807050412.GA23960@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 01:04:12PM +0800, Fengguang Wu wrote:

> FYI, here is a different back trace on that commit.
> 
> [    3.255043] ======================================================
> [    3.255052] [ INFO: possible circular locking dependency detected ]
> [    3.255052] 3.5.0-rc6-bisect-00355-geb04c28 #4 Not tainted         
> [    3.255052] -------------------------------------------------------
> [    3.255052] init/1 is trying to acquire lock:
> [    3.255052]  (&mm->mmap_sem){++++++}, at: [<ffffffff81180d00>] might_fault+0x70/0xe0
> [    3.255052]
> [    3.255052] but task is already holding lock:
> [    3.255052]  (&sb->s_type->i_mutex_key){+.+.+.}, at: [<ffffffff811d191e>] vfs_readdir+0x6e/0x130

Do you see any similar with the _next_ commit?
