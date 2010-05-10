Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab0EJPY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:24:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41843 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab0EJPY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:24:56 -0400
Message-ID: <4BE8252B.8020208@zytor.com>
Date: Mon, 10 May 2010 08:24:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Brian Gerst <brgerst@gmail.com>,
       Dexuan Cui <dexuan.cui@intel.com>, Sheng Yang <sheng@linux.intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v3 0/2] x86 FPU API
References: <1273135546-29690-1-git-send-email-avi@redhat.com> <4BE7C857.1000600@redhat.com>
In-Reply-To: <4BE7C857.1000600@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2010 01:48 AM, Avi Kivity wrote:
> On 05/06/2010 11:45 AM, Avi Kivity wrote:
>> Currently all fpu accessors are wedded to task_struct.  However kvm
>> also uses
>> the fpu in a different context.  Introduce an FPU API, and replace the
>> current uses with the new API.
>>
>> While this patchset is oriented towards deeper changes, as a first
>> step it
>> simlifies xsave for kvm.
>>    
> 
> Peter/Ingo, what are the plans for merging it?  The kvm xsave work
> depends on this.
> 

Going to look at it today.  Looks good, but I want to go over it in
detail to catch any gotchas.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

