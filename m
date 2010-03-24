Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0CXPuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:50:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab0CXPuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:50:02 -0400
Message-ID: <4BAA3496.2010901@redhat.com>
Date: Wed, 24 Mar 2010 17:49:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100323182153.GA14800@8bytes.org> <4BA99BCB.5080501@redhat.com> <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org> <4BAA1A53.20207@redhat.com> <20100324150137.GE14800@8bytes.org> <4BAA2BF7.4060407@redhat.com> <20100324154605.GG14800@8bytes.org>
In-Reply-To: <20100324154605.GG14800@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 05:46 PM, Joerg Roedel wrote:
> On Wed, Mar 24, 2010 at 05:12:55PM +0200, Avi Kivity wrote:
>    
>> On 03/24/2010 05:01 PM, Joerg Roedel wrote:
>>      
>>> $ cd /sys/kvm/guest0
>>> $ ls -l
>>> -r-------- 1 root root 0 2009-08-17 12:05 name
>>> dr-x------ 1 root root 0 2009-08-17 12:05 fs
>>> $ cat name
>>> guest0
>>> $ # ...
>>>
>>> The fs/ directory is used as the mount point for the guest root fs.
>>>        
>> The problem is /sys/kvm, not /sys/kvm/fs.
>>      
> I am not tied to /sys/kvm. We could also use /proc/<pid>/kvm/ for
> example. This would keep anything in the process space (except for the
> global list of VMs which we should have anyway).
>    

How about ~/.qemu/guests/$pid?

-- 
error compiling committee.c: too many arguments to function

