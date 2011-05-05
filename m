Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab1EECHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 22:07:30 -0400
Received: from trent.utfs.org ([194.246.123.103]:43784 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab1EECHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 22:07:30 -0400
Date: Wed, 4 May 2011 19:07:27 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110504231549.GA25956@dastard>
Message-ID: <alpine.DEB.2.01.1105041901380.18728@trent.utfs.org>
References: <20110501080149.GD13542@dastard> <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org> <20110502121958.GA2978@dastard> <alpine.DEB.2.01.1105021247410.18728@trent.utfs.org> <20110503005114.GE2978@dastard> <alpine.DEB.2.01.1105031345090.18728@trent.utfs.org>
 <alpine.DEB.2.01.1105031740460.18728@trent.utfs.org> <20110504073615.GD9114@dastard> <20110504111211.GF9114@dastard> <alpine.DEB.2.01.1105041205340.18728@trent.utfs.org> <20110504231549.GA25956@dastard>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011 at 09:15, Dave Chinner wrote:
> I'll push the fix through the XFS tree to mainline. Thanks for all
> your effort helping me understand and debug the problem, Christian.

OK, I gave it some more testing and compiled the kernel wit UP and 
TINY_RCU again and with your patch applied to -rc6 I could not reproduce 
the issue any more. Plain -rc6 still has the OOM problem.

Feel free to add:

  Tested-By: Christian Kujau <lists@nerdbynature.de>

Again, thanks so much for staying with me and guiding me through all the 
debug steps. And all your effort fixing such a rare setup. I hope more 
people will share the joy :-)

Christian.
-- 
BOFH excuse #164:

root rot
