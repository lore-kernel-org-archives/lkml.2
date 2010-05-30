Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab0E3JO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 05:14:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab0E3JOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 05:14:25 -0400
Message-ID: <4C022C6D.7070701@redhat.com>
Date: Sun, 30 May 2010 12:14:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zamsden@redhat.com
Subject: Re: [PATCH] Add Documentation/kvm/msr.txt
References: <1274897088-8587-1-git-send-email-glommer@redhat.com> <4BFE2A2F.50209@redhat.com> <20100527160248.GF3445@mothafucka.localdomain>
In-Reply-To: <20100527160248.GF3445@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 07:02 PM, Glauber Costa wrote:
>>
>>> +
>>> +Custom MSR list
>>> +--------
>>> +
>>> +The current supported Custom MSR list is:
>>> +
>>> +MSR_KVM_WALL_CLOCK:  0x11
>>> +
>>> +	data: physical address of a memory area.
>>>        
>> Which must be in guest RAM (i.e., don't point it somewhere random
>> and expect the hypervisor to allocate it for you).
>>
>> Must be aligned to 4 bytes (we don't enforce it though).
>>      
> I don't see the reason for it.
>    

Insurance.

> If this is a requirement, our own implementation
> is failing to meet it.
>    

How are we failing to meet it?  All guests align to at least four bytes.

-- 
error compiling committee.c: too many arguments to function

