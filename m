Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159Ab0HELqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:46:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:50375 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab0HELqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:46:34 -0400
Message-ID: <4C5AA42E.7090302@kernel.org>
Date: Thu, 05 Aug 2010 13:44:46 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Richard Kennedy <richard@rsk.demon.co.uk>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org
Subject: Re: [PATCH] stop_machine: struct cpu_stopper, remove alignment padding
 on 64 bits
References: <1281006717.2000.12.camel@castor.rsk> <1281008435.1923.1820.camel@laptop>
In-Reply-To: <1281008435.1923.1820.camel@laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 11:46:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On 08/05/2010 01:40 PM, Peter Zijlstra wrote:
> On Thu, 2010-08-05 at 12:11 +0100, Richard Kennedy wrote:
>> Reorder elements in structure cpu_stopper to remove alignment padding on
>> 64 bit builds, this shrinks its size from 40 to 32 bytes saving 8 bytes
>> per cpu.
>>
>> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> Looks good to me. Tejun will you take it or should I send it Ingo wards?

I already asked whether Andrew could take it but routing through
Ingo's tree would be good too.  Let's wait for Andrew a bit for now.

Thank you.

-- 
tejun
