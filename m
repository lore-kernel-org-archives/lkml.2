Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1EDBvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 21:51:23 -0400
Received: from trent.utfs.org ([194.246.123.103]:54684 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab1EDBvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 21:51:22 -0400
Date: Tue, 3 May 2011 18:51:19 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <alpine.DEB.2.01.1105031740460.18728@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1105031849560.18728@trent.utfs.org>
References: <20110427102824.GI12436@dastard> <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org> <20110428233751.GR12436@dastard> <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org> <20110429201701.GA13166@x4.trippels.de> <alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
 <20110501080149.GD13542@dastard> <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org> <20110502121958.GA2978@dastard> <alpine.DEB.2.01.1105021247410.18728@trent.utfs.org> <20110503005114.GE2978@dastard> <alpine.DEB.2.01.1105031345090.18728@trent.utfs.org>
 <alpine.DEB.2.01.1105031740460.18728@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 May 2011 at 17:46, Christian Kujau wrote:
> And another one, please see the files marked with 15- here:
> 
>    https://trent.utfs.org/p/bits/2.6.39-rc4/oom/trace/
> 
> I tried to have more concise timestamps in each of these files, hope that 
> helps. Sadly though, trace-cmd reports still segfaults on the tracefile.

Running "trace-cmd report" on an i386 machine with those trace.dat files 
did not segfault. I've uploaded/will upload the reports to the url above.

Christian.
-- 
BOFH excuse #186:

permission denied
