Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab2LDAGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 19:06:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab2LDAGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 19:06:48 -0500
Date: Mon, 3 Dec 2012 16:06:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Hunt <johunt@akamai.com>
Cc: jaxboe@fusionio.com, kay.sievers@vrfy.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: Restore /proc/partitions to not display
 non-partitionable removable devices
Message-Id: <20121203160647.11ad34d8.akpm@linux-foundation.org>
In-Reply-To: <1353380209-23799-1-git-send-email-johunt@akamai.com>
References: <1353380209-23799-1-git-send-email-johunt@akamai.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012 18:56:49 -0800
Josh Hunt <johunt@akamai.com> wrote:

> We found with newer kernels we started seeing the cdrom device showing
> up in /proc/partitions, but it was not there before. Looking into this I found
> that commit d27769ec... block: add GENHD_FL_NO_PART_SCAN introduces this change
> in behavior. It's not clear to me from the commit's changelog if this change was
> intentional or not. This comment still remains:
> /* Don't show non-partitionable removeable devices or empty devices */
> so I've decided to send a patch to restore the behavior of not printing
> unpartitionable removable devices.

d27769ec was merged in August 2011, so I after all this time, your fix
could be viewed as "changing existing behaviour".

So perhaps it would be best to leave things alone.  Is there any
particular problem with the post-Aug, 2011 behaviour?
