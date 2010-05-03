Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab0ECMoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 08:44:38 -0400
Received: from anguilla.debian.or.at ([86.59.21.37]:35468 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab0ECMoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 08:44:37 -0400
Date: Mon, 3 May 2010 14:44:36 +0200
From: Peter Palfrader <peter@palfrader.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, stable@kernel.org
Subject: Re: [regression,bisected] 2.6.32.12: find(1) on xfs causes OOM
Message-ID: <20100503124436.GB16623@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, stable@kernel.org
References: <20100503115438.GA16623@anguilla.noreply.org> <20100503123606.GG2591@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100503123606.GG2591@dastard>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 May 2010, Dave Chinner wrote:

> > Starting in 2.6.32.12 running something like "find | wc -l" on this
> > filesystem's mountpoint causes the OOM killer to kill off most of the
> > system.  (See kern.log[1])
> 
> Knwon problem.

> The fix for this problem only got to mainline a couple of days ago.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9bf729c0af67897ea8498ce17c29b0683f7f2028
> 
> I've got to backport it to the stable kernel tree so the next stable
> kernel should fix this.

Thanks, I'll stay on .11 on that machine for now then.

-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
