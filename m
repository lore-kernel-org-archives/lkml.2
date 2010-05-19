Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0ESSr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:47:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab0ESSrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:47:55 -0400
Message-ID: <4BF43256.1090004@redhat.com>
Date: Wed, 19 May 2010 21:47:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ky Srinivasan <ksrinivasan@novell.com>, greg@kroah.com,
       hjanssen@microsoft.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Hyperv detection - code cleanup
References: <4BF3C7970200003000085602@sinclair.provo.novell.com> <4BF4252E.6090609@zytor.com>
In-Reply-To: <4BF4252E.6090609@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 08:51 PM, H. Peter Anvin wrote:
> On 05/19/2010 10:12 AM, Ky Srinivasan wrote:
>    
>> From: K. Y. Srinivasan<ksrinivasan@novell.com>
>> Subject: Code cleanup - consolidate all hyperv related definitions into one
>> header file.
>>
>>      
> How will this affect KVM?  I was under the impression that this was
> separated out as a constants-only header file for a reason.
>
>    

It's exported, so any types need to be compatible with userspace (i.e. 
__u32).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

