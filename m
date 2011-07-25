Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1GYXip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 19:38:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001Ab1GYXij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 19:38:39 -0400
Date: Mon, 25 Jul 2011 16:37:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Roland Dreier <roland@purestorage.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Message-Id: <20110725163739.5c19b04d.akpm@linux-foundation.org>
In-Reply-To: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jul 2011 16:16:15 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> Please go ahead and pull from:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/nab/target-pending.git for-linus-merge

i386 allyesconfig:

ERROR: "__udivdi3" [drivers/target/target_core_mod.ko] undefined!

somewhere in drivers/target/target_core_transport.c:transport_allocate_data_tasks().
