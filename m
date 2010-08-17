Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab0HQIdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:33:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab0HQIdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:33:36 -0400
Message-ID: <4C6A4A58.2030904@cn.fujitsu.com>
Date: Tue, 17 Aug 2010 16:37:44 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [tracing, hang] dumping events gets stuck in synchronise_sched
References: <20100817073725.GO10429@dastard>
In-Reply-To: <20100817073725.GO10429@dastard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2010 03:37 PM, Dave Chinner wrote:
> Tracing folks,
> 
> I've got a machine stuck with a cpu spinning in a tight loop (the
> new writeback/sync livelock avoidance code is, well, livelocking),
> and I was trying to find out what triggered by using the writeback
> trace events. Unfortunately, I can't dump the trace events because
> it gets stuck here:

> 
> Given that the trace events are there mainly for debugging, this
> seems like a bit of an oversight - hanging a CPU in a tight loop is
> not an uncommon event during code development....
> 

You can try 'cat trace_pipe', if I did not miss you meaning.

Lai

