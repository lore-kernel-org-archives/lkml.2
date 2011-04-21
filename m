Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1DUFmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 01:42:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1DUFmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 01:42:31 -0400
Message-ID: <4DAFC3C1.4000908@monstr.eu>
Date: Thu, 21 Apr 2011 07:42:25 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] ftrace: Build without frame pointers on Microblaze
References: <1301908812-8119-1-git-send-email-monstr@monstr.eu>	 <1301908812-8119-2-git-send-email-monstr@monstr.eu>	 <4DA698BA.6020506@monstr.eu> <1303352226.7181.109.camel@gandalf.stny.rr.com>
In-Reply-To: <1303352226.7181.109.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2011-04-14 at 08:48 +0200, Michal Simek wrote:
>> Hi Ingo, [cc: Steven and Frederic]
>>
>> can you please add this patch to your tree?
>>
> 
> Sorry, I've been traveling and I'm behind on email. I'll queue this up.
> Is this needed for 2.6.39 or can it wait to 2.6.40?

No problem. It is fix and it could go to 2.6.39. But it is up to you.

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
