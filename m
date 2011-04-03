Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab1DCNJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 09:09:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53096 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1DCNJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 09:09:05 -0400
Message-ID: <4D98716D.9040307@codemonkey.ws>
Date: Sun, 03 Apr 2011 08:09:01 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com, mingo@elte.hu
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar>	<4D982E89.8070502@redhat.com> <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com> <4D9847BC.9060906@redhat.com>
In-Reply-To: <4D9847BC.9060906@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2011 05:11 AM, Avi Kivity wrote:
> On 04/03/2011 12:59 PM, Pekka Enberg wrote:
>> Hi Avi,
>>
>> On Sun, Apr 3, 2011 at 11:23 AM, Avi Kivity<avi@redhat.com>  wrote:
>> >>  Note that this is a development prototype for the time being: 
>> there's no
>> >>  networking support and no graphics support, amongst other missing
>> >>  essentials.
>> >
>> >  Mind posting a roadmap?  I would put smp support near the top.  
>> This sort of
>> >  thing has to be designed in, otherwise you wind up with a big lock 
>> like
>> >  qemu.
>>
>> What are the pain points with qemu at the moment?
>
> It's an ugly gooball.

Because it solves a lot of very difficult problems.

You could drop all of the TCG support and it'd still be an ugly gooball.

Supporting lots of different emulated hardware devices, live migration, 
tons of different types of networking and image formats, etc., all adds 
up over time.

>> SMP, networking, and simpler guest to host communication from shell
>> are most interesting missing features for me.
>
> If it is to be more than a toy, then Windows (really generic guest) 
> support, manageability, live migration, hotplug, etc. are all crucial.

I concur that SMP is probably one of those features you need to start 
with if you're designing something from scratch.

Regards,

Anthony Liguori

