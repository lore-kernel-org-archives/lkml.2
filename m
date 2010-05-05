Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042Ab0EEJiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:38:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:37657 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257Ab0EEJiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:38:21 -0400
Message-ID: <4BE13C76.2010507@kernel.org>
Date: Wed, 05 May 2010 11:37:58 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu, efault@gmx.de,
       avi@redhat.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] perf: add perf_event_task_migrate()
References: <1272976724-14312-1-git-send-email-tj@kernel.org>	 <1272976724-14312-4-git-send-email-tj@kernel.org>	 <20100505050846.GG5427@nowhere> <1273050684.1642.231.camel@laptop>
In-Reply-To: <1273050684.1642.231.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 09:38:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 11:11 AM, Peter Zijlstra wrote:
> On Wed, 2010-05-05 at 07:08 +0200, Frederic Weisbecker wrote:
>>
>> In fact why not moving both tracing calls under this check.
>> This is going to fix the migrate trace event that gets called
>> even on "spurious" migrations, and you avoid the duplicate check
>> in the perf callback. 
> 
> I kept the tracepoint out of that because I wanted to see how often it
> attempts silly migrations :-)

Do you still need to keep it or is it okay to move it under the
silliness check?

Thanks.

-- 
tejun
