Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0D0SEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:04:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509Ab0D0SEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:04:00 -0400
Message-ID: <4BD7270B.3030201@redhat.com>
Date: Tue, 27 Apr 2010 21:03:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] don't compute pvclock adjustments if we trust the
 tsc
References: <1272303988-21929-1-git-send-email-glommer@redhat.com> <1272303988-21929-2-git-send-email-glommer@redhat.com> <1272303988-21929-3-git-send-email-glommer@redhat.com> <1272303988-21929-4-git-send-email-glommer@redhat.com> <1272303988-21929-5-git-send-email-glommer@redhat.com> <1272303988-21929-6-git-send-email-glommer@redhat.com> <1272303988-21929-7-git-send-email-glommer@redhat.com> <20100427134013.GE18410@amt.cnet>
In-Reply-To: <20100427134013.GE18410@amt.cnet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 04:40 PM, Marcelo Tosatti wrote:
> On Mon, Apr 26, 2010 at 01:46:28PM -0400, Glauber Costa wrote:
>    
>> If the HV told us we can fully trust the TSC, skip any
>> correction
>>
>>      
> Please drop this. Its not certain what is the best method to reduce
> contention on the global variable. Whatever it is, can be done later.
>
>    

The problem is lead time.  If we (or the cpu vendors) fix this in the 
hypervisor/processors in a year, then we want existing guests to take 
advantage of it immediately.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

