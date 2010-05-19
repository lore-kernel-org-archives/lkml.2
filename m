Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab0ESUGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:06:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60147 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873Ab0ESUGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:06:15 -0400
Message-ID: <4BF444A9.6090709@zytor.com>
Date: Wed, 19 May 2010 13:06:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ky Srinivasan <ksrinivasan@novell.com>, greg@kroah.com,
       hjanssen@microsoft.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Hyperv detection - code cleanup
References: <4BF3C7970200003000085602@sinclair.provo.novell.com> <4BF4252E.6090609@zytor.com> <4BF43256.1090004@redhat.com>
In-Reply-To: <4BF43256.1090004@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 11:47 AM, Avi Kivity wrote:
> On 05/19/2010 08:51 PM, H. Peter Anvin wrote:
>> On 05/19/2010 10:12 AM, Ky Srinivasan wrote:
>>    
>>> From: K. Y. Srinivasan<ksrinivasan@novell.com>
>>> Subject: Code cleanup - consolidate all hyperv related definitions into one
>>> header file.
>>>
>>>      
>> How will this affect KVM?  I was under the impression that this was
>> separated out as a constants-only header file for a reason.
> 
> It's exported, so any types need to be compatible with userspace (i.e. 
> __u32).
> 

... and certainly no prototypes for kernel-only functionality.
Right, that's what I thought.  So NAK on this patch, too.

	-hpa
