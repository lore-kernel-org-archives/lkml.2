Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab0EDGhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 02:37:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:43111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab0EDGho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 02:37:44 -0400
Message-ID: <4BDFC079.6000601@kernel.org>
Date: Tue, 04 May 2010 08:36:41 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       oleg@redhat.com, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/4] cpu_stop: implement stop_cpu[s]()
References: <1271952554-22368-1-git-send-email-tj@kernel.org>	 <1271952554-22368-2-git-send-email-tj@kernel.org> <1272893189.5605.120.camel@twins>
In-Reply-To: <1272893189.5605.120.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 06:36:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 03:26 PM, Peter Zijlstra wrote:
> On Thu, 2010-04-22 at 18:09 +0200, Tejun Heo wrote:
>> +void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void
>> *arg,
>> +                       struct cpu_stop_work *work_buf)
>> +{
>> +       memset(work_buf, 0, sizeof(*work_buf));
>> +       work_buf->fn = fn;
>> +       work_buf->arg = arg; 
> 
>  *work_buf = (struct cpu_stop_work){ .fn = fn, .arg = arg, };
> 

Updated.

-- 
tejun
