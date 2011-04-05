Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1DEQAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:00:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41718 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1DEQAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:00:43 -0400
Subject: Re: [PATCH 00/21] sched: Reduce runqueue lock contention -v6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>
Cc: Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110405152338.692966333@chello.nl>
References: <20110405152338.692966333@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 17:59:48 +0200
Message-ID: <1302019188.2225.1348.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 17:23 +0200, Peter Zijlstra wrote:
> 
> unpatched: run time 30 seconds 647278 worker burns per second
> patched:   run time 30 seconds 816715 worker burns per second 

Obviously bigger is better :-), the above means 26% more wakeups
processed in the 30 seconds.
