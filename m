Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0GVEgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 00:36:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab0GVEgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 00:36:17 -0400
Message-ID: <4C47CABC.1080801@redhat.com>
Date: Thu, 22 Jul 2010 07:36:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC][PATCH 9/9] make kvm mmu shrinker more aggressive
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>	 <20100615135530.4565745D@kernel.beaverton.ibm.com>	 <4C189830.2070300@redhat.com>  <1276701911.6437.16973.camel@nimitz>	 <1276876156.6437.23323.camel@nimitz>  <4C1DCD1A.4010306@redhat.com> <1277224359.9782.21.camel@nimitz>
In-Reply-To: <1277224359.9782.21.camel@nimitz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2010 07:32 PM, Dave Hansen wrote:
> On Sun, 2010-06-20 at 11:11 +0300, Avi Kivity wrote:
>    
>>> That changes a few things.  I bet all the contention we were seeing was
>>> just from nr_to_scan=0 calls and not from actual shrink operations.
>>> Perhaps we should just stop this set after patch 4.
>>>
>>>        
>> At the very least, we should re-measure things.
>>      
> Sure.  I'll go back to the folks that found this in the first place and
> see how these patches affect the contention we were seeing.
>    

Dave, how did those tests go?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

