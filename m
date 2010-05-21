Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0EUNZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:25:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:36948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab0EUNZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:25:57 -0400
Message-ID: <4BF689DD.2090306@kernel.org>
Date: Fri, 21 May 2010 15:25:49 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET sched/core] sched: prepare for cmwq
References: <1273747705-7829-1-git-send-email-tj@kernel.org> <4BF1CD92.9030800@kernel.org>
In-Reply-To: <4BF1CD92.9030800@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 13:25:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter, Ingo.

On 05/18/2010 01:13 AM, Tejun Heo wrote:
> On 05/13/2010 12:48 PM, Tejun Heo wrote:
>> These four patches are the scheduler modifications necessary for cmwq
>> and contains the following four patches.
> 
> Ping.
> 

I know we're inside -rc1 merge window but I'm really hoping to push
cmwq through linux-next during this devel cycle as the whole thing
basically has been blocked unchanged on scheduler changes for a couple
of months now.  So, can we please get this thing moving?

Thanks.

-- 
tejun
