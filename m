Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab0FPX7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 19:59:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0FPX7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 19:59:53 -0400
Message-ID: <4C196570.5080803@redhat.com>
Date: Wed, 16 Jun 2010 13:59:44 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/17] Add timekeeping documentation
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>	<1276587259-32319-18-git-send-email-zamsden@redhat.com> <20100615132755.9b8d9041.randy.dunlap@oracle.com>
In-Reply-To: <20100615132755.9b8d9041.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 10:27 AM, Randy Dunlap wrote:
> On Mon, 14 Jun 2010 21:34:19 -1000 Zachary Amsden wrote:
>
>    
>> Basic informational document about x86 timekeeping and how KVM
>> is affected.
>>      
> Nice job/information.  Thanks.
>
> Just some typos etc. inline below.
>    

Thanks for all the detailed feedback!  I'll include it all in the next 
revision.  I only have one response:
>
>> + low, the count is halted.  If the output is low when the gate is lowered, the
>> + output automatically goes high (this only affects timer 2).
>> +
>> +Mode 3: Square Wave.   This generates a sine wave.  The count determines the
>>      
> a sine wave is a square wave???
>    

Actually, yes.  The hardware output from timer 2 output goes through a 
low pass filter which effectively smooths the square wave to a sine to 
make the PC speaker sound somewhat less annoying.  I didn't have room to 
depict this in the schematic.  Of course, the counter output isn't 
directly a sine wave, and the LPF may not be all that effective, but it 
was the intent.

Zach
