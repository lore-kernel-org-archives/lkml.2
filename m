Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab2EJK4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:56:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41114 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932196Ab2EJK4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:56:03 -0400
Message-ID: <4FAB9EC0.8090905@openvz.org>
Date: Thu, 10 May 2012 14:56:00 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: set TAINT_UNSAFE_SMP after sleep-in-atomic bug
References: <20120510075403.21849.5109.stgit@zurg> <1336644104.2527.93.camel@twins>
In-Reply-To: <1336644104.2527.93.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2012-05-10 at 11:54 +0400, Konstantin Khlebnikov wrote:
>> Usually sleep-in-atomic bugs are followed by dozens other warnings.
>> This patch should help to figure out original source of problem.
>> This taint flag also turns off lockdep, because it can go mad after that.
>
> There's already TAINT_WARN any output with that set should be ignored.

Where? I do not see here anything which might set TAINT_WARN.

Or you suggest to use TAINT_WARN instead of TAINT_UNSAFE_SMP?
