Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0DFQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab0DFQ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:28:09 -0400
Message-ID: <4BBB6110.2080505@redhat.com>
Date: Tue, 06 Apr 2010 19:28:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Dmitry Torokhov <dtor@vmware.com>,
       linux-kernel@vger.kernel.org, pv-drivers@vmware.com,
       Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>	<20100405142419.2c9bea3d.akpm@linux-foundation.org>	<4BBA5E1C.10706@goop.org>	<20100405151720.8a6ac5e3.akpm@linux-foundation.org>	<4BBA6383.7070601@redhat.com> <20100405154023.c7e4f877.akpm@linux-foundation.org>
In-Reply-To: <20100405154023.c7e4f877.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 01:40 AM, Andrew Morton wrote:
> On Tue, 06 Apr 2010 01:26:11 +0300
> Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 04/06/2010 01:17 AM, Andrew Morton wrote:
>>      
>>>> The basic idea of the driver is to allow a guest system to give up
>>>> memory it isn't using so it can be reused by other virtual machines (or
>>>> the host itself).
>>>>
>>>>          
>>> So...  does this differ in any fundamental way from what hibernation
>>> does, via shrink_all_memory()?
>>>
>>>        
>> Just the _all_ bit, and the fact that we need to report the freed page
>> numbers to the hypervisor.
>>
>>      
> So...  why not tweak that, rather than implementing some parallel thing?
>    

That's maybe 5 lines of code.  Most of the code is focused on 
interpreting requests from the hypervisor and replying with the page 
numbers.

-- 
error compiling committee.c: too many arguments to function

