Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab1EWW43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:56:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38262 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1EWW42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:56:28 -0400
Message-ID: <4DDAE5FA.2030303@kernel.org>
Date: Mon, 23 May 2011 15:55:54 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage based
 on semi-formal proof"
References: <4DD6D746.6070107@kernel.org> <20110520224250.GL2366@linux.vnet.ibm.com> <4DD6F4A2.1070401@kernel.org> <20110520231428.GN2366@linux.vnet.ibm.com> <4DD6F64C.3030402@kernel.org> <20110520234923.GQ2366@linux.vnet.ibm.com> <4DD70120.9090801@kernel.org> <20110521131844.GE2271@linux.vnet.ibm.com> <20110521140845.GA12157@linux.vnet.ibm.com> <4DDAC01E.7050602@kernel.org> <20110523212530.GF7428@linux.vnet.ibm.com> <4DDAD934.9010603@kernel.org>
In-Reply-To: <4DDAD934.9010603@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4DDAE601.0036,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2011 03:01 PM, Yinghai Lu wrote:
> On 05/23/2011 02:25 PM, Paul E. McKenney wrote:
>> On Mon, May 23, 2011 at 01:14:22PM -0700, Yinghai Lu wrote:
>>> On 05/21/2011 07:08 AM, Paul E. McKenney wrote:
>>>> On Sat, May 21, 2011 at 06:18:44AM -0700, Paul E. McKenney wrote:
>>>>> On Fri, May 20, 2011 at 05:02:40PM -0700, Yinghai Lu wrote:
>>>>>> On 05/20/2011 04:49 PM, Paul E. McKenney wrote:
>>>>>>> On Fri, May 20, 2011 at 04:16:28PM -0700, Yinghai Lu wrote:
>>>>>> ...
>>>>>>>>
>>>>>>>> the same one i sent out before, but let DEBUG_LOCKING_API_SELFTESTS disabled.
>>>>>>>
>>>>>>> OK, just to make sure I understand...  You are compiling exactly the
>>>>>>> same kernel source tree with exactly the same .config, just with two
>>>>>>> different versions of gcc, correct?
>>>>>> yes.
>>>>>>>
>>>>>>> If so, it is quite possible that the slow one is the correct one.  :-/
>>>>>> yeah, new version always have problem.
>>>>>>
>>>>>> looks like opensuse11.3 has 4.5.0 and fedora14 has 4.5.1
>>>>>
>>>>> OK, so fedora14 is the fast one (4.5.1) and opensuse11.3 is the slow
>>>>> one (4.5.0), correct?
>>>>
>>>> And does commit c7a3786030 help?  This commit (from Peter Zijlstra)
>>>> tidied up RCU kthreads' scheduler interactions.  The patch is below,
>>>> though it is probably more convenient to pull it from the rcu/next
>>>> branch of:
>>>>
>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
>>>>
>>
gcc in Fedora 14 is fine with your tree.

Looks like I need to dump openuse 11.3 now.

Thanks

Yinghai
