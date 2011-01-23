Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1AWX5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 18:57:51 -0500
Received: from trent.utfs.org ([194.246.123.103]:48694 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab1AWX5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 18:57:50 -0500
Date: Sun, 23 Jan 2011 15:57:44 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Yong Zhang <yong.zhang0@gmail.com>, Michael Witten <mfwitten@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: 'autogroup' sched code KILLING responsiveness
In-Reply-To: <20110123151556.GA15236@elte.hu>
Message-ID: <alpine.DEB.2.01.1101231554170.7903@trent.utfs.org>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com> <alpine.DEB.2.01.1101230243370.7903@trent.utfs.org> <20110123145429.GA2523@zhy> <20110123151556.GA15236@elte.hu>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011 at 16:15, Ingo Molnar wrote:
> Christian, Michael, can you confirm that this and the second patch fixes the 
> interactivity bug for you? If yes then i'd like to apply and send this fix to Linus 
> ASAP.

Running with both patches applied for some time now and the same (or 
slightly bigger workload) than before, system load is fine and 
responsiveness is much better, just like w/o the autogroup feature.

Feel free to add:

Tested-by: Christian Kujau <lists@nerdbynature.de>

Thanks to all involved,
Christian.
-- 
BOFH excuse #431:

Borg implants are failing
