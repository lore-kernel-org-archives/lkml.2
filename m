Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab1E1EEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 00:04:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25084 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab1E1EEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 00:04:00 -0400
Message-ID: <4DE07413.5050408@kernel.org>
Date: Fri, 27 May 2011 21:03:31 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage based
 on semi-formal proof"
References: <4DDC21E1.1070502@kernel.org> <4DDC48E3.1060108@kernel.org> <20110525045253.GB2262@linux.vnet.ibm.com> <4DDD7F96.3090408@kernel.org> <20110525223437.GO2341@linux.vnet.ibm.com> <4DDD8775.1000501@kernel.org> <20110526011310.GP2341@linux.vnet.ibm.com> <20110526013029.GA28103@linux.vnet.ibm.com> <BANLkTinC2q6Fjf7=2GZoJ=+c+fzpdwAvuQ@mail.gmail.com> <20110526162802.GC2386@linux.vnet.ibm.com> <20110528010448.GA21955@linux.vnet.ibm.com>
In-Reply-To: <20110528010448.GA21955@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4DE0741D.0034,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2011 06:04 PM, Paul E. McKenney wrote:
> 
> And, after having repeatedly shot myself in the foot trying to make
> an all-singing all-dancing RCU grace-period latency measurement tool,
> I fell back to simply measuring the RCU grace-period latency during
> the time that memory_dev_init() is running.  This assumes that the
> grace periods are started using synchronize_rcu() -- if they are instead
> being started using call_rcu(), I can adapt to that as well.
> 
[   31.635137] cpu_dev_init done
[   31.635320] Starting RCU latency diagnostics
[   71.605662] Ending RCU latency diagnostics
[   71.605924] memory_dev_init done


Thanks

Yinghai
