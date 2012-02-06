Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab2BFMtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:49:43 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:47648 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab2BFMtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:49:42 -0500
Date: Mon, 6 Feb 2012 16:52:50 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: No /dev/root with devtmpfs?
Message-ID: <20120206125250.GA13217@tugrik.mns.mnsspb.ru>
References: <20120206111853.GA11506@tugrik.mns.mnsspb.ru>
 <1328530227.72508.YahooMailClassic@web29004.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328530227.72508.YahooMailClassic@web29004.mail.ird.yahoo.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 12:10:27PM +0000, Paul Parsons wrote:
> --- On Mon, 6/2/12, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> > Is it somehow possible to add /dev/root to devtmpfs?
> 
> Or alternatively have /proc/mounts report the actual root device
> instead of "/dev/root" ?

Sorry, I have not included that info originally. No, it shows /dev/root
there too:

    root@(none):/# cat /proc/mounts 
    rootfs / rootfs rw 0 0
    /dev/root / ext3 ro,relatime,barrier=0,data=writeback 0 0
    devtmpfs /dev devtmpfs rw,relatime,size=61564k,nr_inodes=15391,mode=755 0 0
    tmpfs /lib/init/rw tmpfs rw,nosuid,relatime,mode=755 0 0
    proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
    sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
