Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1EUADX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:03:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40142 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406Ab1EUADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:03:08 -0400
Message-ID: <4DD70120.9090801@kernel.org>
Date: Fri, 20 May 2011 17:02:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage based
 on semi-formal proof"
References: <tip-80d02085d99039b3b7f3a73c8896226b0cb1ba07@git.kernel.org> <4DD6D746.6070107@kernel.org> <20110520224250.GL2366@linux.vnet.ibm.com> <4DD6F4A2.1070401@kernel.org> <20110520231428.GN2366@linux.vnet.ibm.com> <4DD6F64C.3030402@kernel.org> <20110520234923.GQ2366@linux.vnet.ibm.com>
In-Reply-To: <20110520234923.GQ2366@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4DD70128.0038,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2011 04:49 PM, Paul E. McKenney wrote:
> On Fri, May 20, 2011 at 04:16:28PM -0700, Yinghai Lu wrote:
...
>>
>> the same one i sent out before, but let DEBUG_LOCKING_API_SELFTESTS disabled.
> 
> OK, just to make sure I understand...  You are compiling exactly the
> same kernel source tree with exactly the same .config, just with two
> different versions of gcc, correct?
yes.
> 
> If so, it is quite possible that the slow one is the correct one.  :-/
yeah, new version always have problem.

looks like opensuse11.3 has 4.5.0 and fedora14 has 4.5.1

Yinghai
