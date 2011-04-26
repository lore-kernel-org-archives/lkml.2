Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab1DZPOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:14:50 -0400
Received: from trent.utfs.org ([194.246.123.103]:58952 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885Ab1DZPOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:14:49 -0400
Date: Tue, 26 Apr 2011 08:14:46 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1104260812130.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <20110424234655.GC12436@dastard> <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org> <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Mon, 25 Apr 2011 at 00:19, Christian Kujau wrote:
> Please see http://nerdbynature.de/bits/2.6.39-rc4/oom/
> 
>  - slabinfo-4.txt.bz2, contains /proc/sys/fs/{dentry,inode}-state and
>    /proc/fs/xfs/stat (is this interesting at all?) and a few other
>    /proc outputs
>  - messages-4.txt, contains the syslog from this run.

did you have time to look at those outputs yet? Do you need some more 
information? Right now 2.6.39-rc4 is not an option for me, 2.6.38 works 
just fine....

Thanks,
Christian.
-- 
BOFH excuse #170:

popper unable to process jumbo kernel
