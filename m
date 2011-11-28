Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1K1MYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:24:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48265 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1K1MYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:24:30 -0500
Date: Mon, 28 Nov 2011 12:24:16 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, Josef Bacik <josef@redhat.com>,
        Miao Xie <miaox@cn.fujitsu.com>,
        Ivan Vilata i Balaguer <ivan@selidor.net>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no
 read/write devices V2
Message-ID: <20111128122416.GA25996@localhost>
References: <1312205910-13053-1-git-send-email-apw@canonical.com>
 <20111128121041.GA19498@elie.hsd1.il.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128121041.GA19498@elie.hsd1.il.comcast.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 06:11:06AM -0600, Jonathan Nieder wrote:
> Hi,
> 
> Andy Whitcroft wrote:
> 
> > When we mount a btrfs filesystem from read-only media there will be no
> > read/write devices; for example mounting an SD card with its lock enabled.
> > This triggers an immediate BUG during mount:
> >
> >   kernel BUG at .../fs/btrfs/super.c:984!
> [...]
> > BugLink: http://bugs.launchpad.net/bugs/816770
> > Signed-off-by: Andy Whitcroft <apw@canonical.com>
> > ---
> 
> Fixes http://bugs.debian.org/649847
> Tested-by: Ivan Vilata i Balaguer <ivan@selidor.net>
> 
> This patch fixes a regression introduced by 6d07bcec969a ("btrfs: fix
> wrong free space information of btrfs"), which hit mainline in
> v2.6.38-rc1.  Josef Bacik acked the patch, but I can't seem to find it
> in linux-next, linux-btrfs, or Josef's btrfs-work tree.  Maybe it was
> just forgotten.
> 
> What can I do to help this patch get unstuck?

I had completely forgotten about this one.  I wonder where it did get
to.  I seem to remember testing this in house successfully.

-apw
