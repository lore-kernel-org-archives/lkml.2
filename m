Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab1D3QZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 12:25:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26440 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1D3QZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 12:25:11 -0400
Message-ID: <4DBC37D0.3070408@kernel.org>
Date: Sat, 30 Apr 2011 09:24:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/25] x86, NUMA: trivial cleanups
References: <1304090924-8197-1-git-send-email-tj@kernel.org> <1304090924-8197-9-git-send-email-tj@kernel.org> <4DBAF498.40007@kernel.org> <20110430120307.GE29280@htj.dyndns.org>
In-Reply-To: <20110430120307.GE29280@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DBC37D6.006B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2011 05:03 AM, Tejun Heo wrote:
> On Fri, Apr 29, 2011 at 10:25:44AM -0700, Yinghai Lu wrote:
>> On 04/29/2011 08:28 AM, Tejun Heo wrote:
>>> * Kill no longer used struct bootnode.
>>>
>>> * Kill dangling declaration of pxm_to_nid() in numa_32.h.
>>>
>>> * Make setup_node_bootmem() static.
>>
>> first one and third one should appear in patches that I posted before.
> 
> Sorry, can't understand what you mean.  What are you trying to say?
> 

I posted two patches for 
Kill no longer used struct bootnode.
Make setup_node_bootmem() static

Also setup_node_bootmem now is some misleading, could change to setup_node_data() ?

Thanks

Yinghai
