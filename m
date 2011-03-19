Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab1CSJE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 05:04:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:52133 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab1CSJES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 05:04:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,209,1299484800"; 
   d="scan'208";a="721872480"
Message-ID: <4D847191.7000806@linux.intel.com>
Date: Sat, 19 Mar 2011 02:04:17 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: clem@clem.clem-digital.net, linux-kernel@vger.kernel.org, mroos@linux.ee,
        sparclinux@vger.kernel.org
Subject: Re: 38-git2-6 -- kernel/futex.c warning
References: <201103181932.p2IJW5cg002394@clem.clem-digital.net> <20110318.125808.233714688.davem@davemloft.net>
In-Reply-To: <20110318.125808.233714688.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/18/2011 12:58 PM, David Miller wrote:
> From: Pete Clements<clem@clem.clem-digital.net>
> Date: Fri, 18 Mar 2011 15:32:05 -0400 (EDT)
>
>> Fyi. Have been experiencing the below since 38-git2. Continual scrolling
>> such that cannot complete system startup. System is i386 UP, Debian "squeeze".
>
> Looks similar to the problems reported by Meelis, CC:'d

yes, and the same answer, see Steven Rostedts patch set from March 17th:

[PATCH 0/2 v2] [GIT PULL] futex: Fix WARN_ON trigging on UP

--
Darren

>
>> WARNING: at kernel/futex.c:786 wake_futex+0x21/0x70()
>> Hardware name: XPST450
>> Modules linked in: ipv6
>> Pid: 1045, comm: rndc Not tainted 2.6.38-git6 #1
>> Call Trace:
>> [<c101eba8>] ? warn_slowpath_common+0x78/0xb0
>> [<c1040b21>] ? wake_futex+0x21/0x70
>> [<c1040b21>] ? wake_futex+0x21/0x70
>> [<c101ebf9>] ? warn_slowpath_null+0x19/0x20
>> [<c1040b21>] ? wake_futex+0x21/0x70
>> [<c10429d9>] ? do_futex+0x629/0x950
>> [<c108f2a3>] ? d_kill+0x73/0xd0
>> [<c1042d78>] ? sys_futex+0x78/0x130
>> [<c107c2dd>] ? filp_close+0x4d/0x80
>> [<c11fa8bd>] ? syscall_call+0x7/0xb
>> ---[ end trace 595c935fe53c9cd0 ]---
>>
>> --
>> Pete Clements
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
