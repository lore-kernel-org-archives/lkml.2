Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0LSVrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:47:41 -0500
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:45154 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757218Ab0LSVrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:47:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=R09A6ZfpE1D2WgF8Hgn4Rz4pel26zKUaxuglFY91xkDO9Uw7rc+7kU5ZDbe1EJEE;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D0E7D43.9010409@earthlink.net>
Date: Sun, 19 Dec 2010 16:46:43 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: I915 driver locks up
References: <4D0D1516.3040404@earthlink.net> <4D0D19FF.4020600@earthlink.net> <5b55a1$j0av6h@fmsmga002.fm.intel.com> <4D0D44A1.8090501@earthlink.net> <5b55a1$j0e7cc@fmsmga002.fm.intel.com>
In-Reply-To: <5b55a1$j0e7cc@fmsmga002.fm.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79efe2793b95e2a07410e0cba1514b85a6350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2010 06:02 AM, Chris Wilson wrote:
> On Sat, 18 Dec 2010 18:32:49 -0500, Stephen Clark<sclark46@earthlink.net>  wrote:
>    
>> I had been using mesa-7.9.
>> I loaded mesa-7.10 similar results. There is no
>>
>> /sys/kernel/debug/dri/0/i915_error_state
>>
>> In fact there is nothing in the /sys/kernel/debug directory. Do I have
>> to enable
>> something.
>>      
> You need to "mount -tdebugfs debug /sys/kernel/debug".
>
>    
>> With the later kernel - things are worse X becomes totally useless it looks
>> like my lcd panel lost horizontal sync. With the 2.6.25 kernel X is
>> still usable
>> this makes me think at least some of the problem is kernel related.
>>      
> 2.6.25 to present marks the transition between UMS and KMS, i.e. moving
> of the userspace modesetting code into the kernel. And that should not
> have regressed. Can you please, grab an intel_reg_dumper of the working
> setup and the lost-sync setup, and include a drm.debug=0xe dmesg (i.e. add
> drm.debug=0xe to your boot commandline)?
>
>    
>> With 2.6.37-rc6 and mesa 7.10 with hardware acceleration turned off in wine-
>>
>> Dec 18 18:01:50 joker4 yum[5244]: Updated: mesa-libGL-7.10-0.17.fc15.x86_64
>> Dec 18 18:01:52 joker4 yum[5244]: Updated: mesa-libGL-7.10-0.17.fc15.i686
>> Dec 18 18:01:54 joker4 yum[5244]: Updated: mesa-libGLU-7.10-0.17.fc15.x86_64
>> Dec 18 18:02:02 joker4 yum[5244]: Updated: mesa-dri-drivers-7.10-0.17.fc15.x86_6
>> 4
>> Dec 18 18:02:03 joker4 yum[5244]: Updated: mesa-libGLU-7.10-0.17.fc15.i686
>> Dec 18 18:02:11 joker4 yum[5244]: Updated: mesa-dri-drivers-7.10-0.17.fc15.i686
>>      
> Good, those drivers are recent enough that I should be able to use the
> error state to find the broken code.
> -Chris
>
>    
Hi Chris,

I emailed the information you requested, it was quite large, and haven't 
seen it show up on
LKML yet. Don't know if it is being blocked by the ML or not.

Regards,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



