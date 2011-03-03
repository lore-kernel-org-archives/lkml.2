Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab1CCS2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:28:05 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:22497 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758644Ab1CCS2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:28:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAENsb01Ld/sX/2dsb2JhbAAMhB3QdJEVgSeDRHYEhRo
X-IronPort-AV: E=Sophos;i="4.62,259,1297054800"; 
   d="scan'208";a="94288826"
Message-ID: <4D6FDDB1.3060209@teksavvy.com>
Date: Thu, 03 Mar 2011 13:28:01 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.14) Gecko/20110221 Thunderbird/3.1.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ken Sumrall <ksumrall@android.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <eparis@redhat.com>, Dave Young <hidave.darkstar@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to
 remount filesystems ro
References: <1299137483-10975-1-git-send-email-ksumrall@android.com> <AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com>
In-Reply-To: <AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-03-03 12:45 PM, Linus Torvalds wrote:
>
> If you can change whatever user-land process that does the reboot
> system call (and clearly you can, since you're adding new commands and
> using those), then why the heck don't you just do the remount-ro from
> that same user land?

Is there a system call for emergency_remount_*() ?
I've been writing to /proc/proc/sysrq-trigger to accomplish this.
