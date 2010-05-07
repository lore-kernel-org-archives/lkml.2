Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0EGRIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:08:54 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:48497 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab0EGRIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:08:53 -0400
Message-ID: <4BE44901.9060508@cs.columbia.edu>
Date: Fri, 07 May 2010 13:08:17 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v21 053/100] c/r (ipc): allow allocation of a desired
 ipc identifier
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu> <1272723382-19470-54-git-send-email-orenl@cs.columbia.edu> <4BE440AD.20300@colorfullife.com>
In-Reply-To: <4BE440AD.20300@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Manfred Spraul wrote:
> Hi Oren,
> 
> 
> On 05/01/2010 04:15 PM, Oren Laadan wrote:
>> @@ -82,7 +82,7 @@ void shm_init_ns(struct ipc_namespace *ns)
>>    * Called with shm_ids.rw_mutex (writer) and the shp structure locked.
>>    * Only shm_ids.rw_mutex remains locked on exit.
>>    */
>> -static void do_shm_rmid(struct ipc_namespace *ns, struct 
>> kern_ipc_perm *ipcp)
>> +void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
>>   {
>>       struct shmid_kernel *shp;
>>       shp = container_of(ipcp, struct shmid_kernel, shm_perm);
>>    
> This hunk appears to be unrelated to the main patch.
> Is it intentional or a left-over from debugging?
> 

Good catch: it belongs in patch 55: "c/r: support shared memory 
sysv-ipc". Will move it there. Thanks for the review.

Oren.

