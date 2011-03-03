Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab1CCOBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:01:01 -0500
Received: from verein.lst.de ([213.95.11.210]:40189 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758413Ab1CCOA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:00:58 -0500
Date: Thu, 3 Mar 2011 15:00:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ken Sumrall <ksumrall@android.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <eparis@redhat.com>, Dave Young <hidave.darkstar@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to remount filesystems ro
Message-ID: <20110303140027.GA8116@lst.de>
References: <1299137483-10975-1-git-send-email-ksumrall@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299137483-10975-1-git-send-email-ksumrall@android.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 11:31:22PM -0800, Ken Sumrall wrote:
> Add 4 new commands to the reboot system call, that do the same thing as the
> RESTART, HALT, POWER_OFF, and RESTART2 commands, but also remount writable
> filesystems as read-only just before doing what the command normally does.
> Now that Android is using EXT4, and since we don't have a standard init
> setup to unmount filesystems before rebooting, this allows the system to
> reboot with clean filesystems, and also improves boot time as the journal
> does not need to be replayed when mounting the filesystem.

Just fix your init.  Or better switch from a piece of shit like Android
userspace to something sane for your phone.

