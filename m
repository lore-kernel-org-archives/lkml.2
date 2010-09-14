Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab0INO2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:28:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab0INO2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:28:52 -0400
Date: Tue, 14 Sep 2010 16:29:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: fix user time incorrectly accounted as system
 time on 32 bit
Message-ID: <20100914142930.GA8415@redhat.com>
References: <1284471892-8433-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284471892-8433-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 03:44:52PM +0200, Stanislaw Gruszka wrote:
> We have 32 bit variable overflow possibility when multiply in
> task_times() and thread_group_times() functions. If overflow happens
> calculated scaled utime value become wrongly small and scaled stime
> wrongly big.
> 
> Reported here:
> https://bugzilla.redhat.com/show_bug.cgi?id=633037
> https://bugzilla.kernel.org/show_bug.cgi?id=16559
> 
> Reported-by: Michael Chapman <redhat-bugzilla@very.puzzling.org>
> Reported-by: Ciriaco Garcia de Celis <sysman@etherpilot.com>
> Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: stable@kernel.org  # 2.6.32.19+ (partially), 2.6.33+

Seems my send-email script screwed recipients, I will repost.

Stanislaw
