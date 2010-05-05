Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab0EEHaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:30:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:38971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab0EEHae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:30:34 -0400
Message-ID: <4BE11E8E.7090600@kernel.org>
Date: Wed, 05 May 2010 09:30:22 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET sched/core] cpu_stop: implement and use cpu_stop, take#2
References: <1272980864-27235-1-git-send-email-tj@kernel.org> <1272999172.1642.208.camel@laptop>
In-Reply-To: <1272999172.1642.208.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 07:30:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 08:52 PM, Peter Zijlstra wrote:
> On Tue, 2010-05-04 at 15:47 +0200, Tejun Heo wrote:
>>
>> Peter, if you ack the series, I'll add refresh the patches w/ your ACK
>> and request pull into sched/core to Ingo. 
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Great, thank you.  As soon as Paul's comment is resolved, I'll push it
to Ingo.

-- 
tejun
