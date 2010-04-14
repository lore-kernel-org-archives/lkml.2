Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0DNSll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 14:41:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab0DNSlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 14:41:40 -0400
Message-ID: <4BC60C2D.2000002@redhat.com>
Date: Wed, 14 Apr 2010 11:40:45 -0700
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
       Ben Gamari <bgamari.foss@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tytso@mit.edu, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Ruald Andreae <ruald.a@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com> <4baeaee5.c5c2f10a.7187.2688@mx.google.com> <20100327204233.0d84542a@infradead.org> <4baf624c.48c3f10a.16d0.ffffccb8@mx.google.com> <87y6hcyu85.fsf@basil.nowhere.org> <4bbf401e.a3b9e70a.13f3.4460@mx.google.com> <4BC1E4A4.1070103@redhat.com> <alpine.LFD.2.00.1004112014520.18009@localhost.localdomain> <20100412002225.GB2493@dastard>
In-Reply-To: <20100412002225.GB2493@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2010 05:22 PM, Dave Chinner wrote:
> On Sun, Apr 11, 2010 at 08:16:09PM +0200, Thomas Gleixner wrote:
>    
>> On Sun, 11 Apr 2010, Avi Kivity wrote:
>>      
>>> On 04/09/2010 05:56 PM, Ben Gamari wrote:
>>>        
>>>> On Mon, 29 Mar 2010 00:08:58 +0200, Andi Kleen<andi@firstfloor.org>   wrote:
>>>>          
>>>>> Ben Gamari<bgamari.foss@gmail.com>   writes:
>>>>> ext4/XFS/JFS/btrfs should be better in this regard
>>>>>
>>>>>            
>>>> I am using btrfs, so yes, I was expecting things to be better.
>>>> Unfortunately,
>>>> the improvement seems to be non-existent under high IO/fsync load.
>>>>          
>>> btrfs is known to perform poorly under fsync.
>>>        
>> XFS does not do much better. Just moved my VM images back to ext for
>> that reason.
>>      
> Numbers? Workload description? Mount options? I hate it when all I
> hear is "XFS sucked, so I went back to extN" reports without any
> more details - it's hard to improve anything without any details
> of the problems.
>
> Also worth remembering is that XFS defaults to slow-but-safe
> options, but ext3 defaults to fast-and-I-don't-give-a-damn-about-
> data-safety, so there's a world of difference between the
> filesystem defaults....
>
> And FWIW, I run all my VMs on XFS using default mkfs and mount options,
> and I can't say that I've noticed any performance problems at all
> despite hammering the IO subsystems all the time. The only thing
> I've ever done is occasionally run xfs_fsr across permanent qcow2
> VM images to defrag them as the grow slowly over time...
>
> Cheers,
>
> Dave.
>    

And if you are asking for details, the type of storage  you use is also 
quite interesting.

Thanks!

Ric

