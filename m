Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2ISO7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:59:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2ISO7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:59:12 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: jaxboe@fusionio.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] block: make struct block_device cacheline_aligned
References: <x49lig686kv.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 19 Sep 2012 10:59:09 -0400
In-Reply-To: <x49lig686kv.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Wed, 19 Sep 2012 09:50:40 -0400")
Message-ID: <x498vc683eq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> Hi,
>
> When testing against a pcie ssd or a ramdisk, making the block device
> structure cacheline_aligned provided a significant increase in
> performance:

Self-NACK on this one.  This results in a ton of warnings:

include/linux/fs.h:727: warning: ???__section__??? attribute does not
apply to types
In file included from include/linux/debugfs.h:18,
                 from kernel/trace/trace_probe.h:28,
                 from kernel/trace/trace_kprobe.c:23:
include/linux/fs.h:727: warning: ???__section__??? attribute does not
apply to types

And that leaves me with the task of figuring out if/why this actually
helps.

Cheers,
Jeff
>
