Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab1AKIYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 03:24:35 -0500
Received: from www.tglx.de ([62.245.132.106]:39383 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab1AKIY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 03:24:28 -0500
Date: Tue, 11 Jan 2011 09:24:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5][RT] [GIT PULL] rt: Port of Lai Jiangshan's rt
 patch
In-Reply-To: <20110111035355.643480133@goodmis.org>
Message-ID: <alpine.LFD.2.00.1101110923020.12146@localhost6.localdomain6>
References: <20110111035355.643480133@goodmis.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011, Steven Rostedt wrote:
> Thomas,
> 
> I finally got Lai's patch to a point that I'm happy with it.
> The first 4 patches are clean ups to help in applying Lai's patch
> at the end.
> 
> I've tested this patch series by running dbench 100 in a loop
> and it crashes as much as mainline 2.6.33 does ;-) so I'm pretty
> happy with it.

Crashes in what way? I'm not so happy about stuff which crashes :)

Thanks,

	tglx
