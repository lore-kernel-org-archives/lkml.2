Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab1DYJu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 05:50:26 -0400
Received: from trent.utfs.org ([194.246.123.103]:57440 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758143Ab1DYJuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 05:50:25 -0400
Date: Mon, 25 Apr 2011 02:50:12 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <alpine.DEB.2.01.1104250053590.18728@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1104250246520.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <20110424234655.GC12436@dastard> <alpine.DEB.2.01.1104250053590.18728@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011 at 01:02, Christian Kujau wrote:
> On Mon, 25 Apr 2011 at 09:46, Dave Chinner wrote:
> > BTW, what are your mount options? If it is the problem I suspect it
> > is, then using noatime with stop it from occurring....
> 
> When mounted with noatime, running du(1) accross the XFS volume still 
> triggered the OOM killer, but the backtrace looked somewhat different 
> this time:

Tried again with noatime, this time no OOM message got logged to the disk 
(but may have been logged to the console early on). As it's reproducible, 
I started du(1) across the XFS volume and after a while my SSH connection 
to the box was lost. That's all I got this time:

  http://nerdbynature.de/bits/2.6.39-rc4/oom/oom-6.JPG
  http://nerdbynature.de/bits/2.6.39-rc4/oom/slabinfo-6.txt.bz2

Christian.
-- 
BOFH excuse #272:

Netscape has crashed
