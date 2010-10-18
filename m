Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0JRORK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:17:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48735 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab0JRORI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:17:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NQLybaYgTQtEz3HlUCuU1osXgp2vxZNKiJHD2HMuQAlc7b9WyxkHnq0zKDjfrql96Z
         4uXWlzBXm32XPvzG0A7MKeMwsaM9eASjL1qF5Zqoc25st30tppBXBHNbfRR+kwBIXtvt
         uSe4dTzTZp7L2CyJY9+Rm+C4GrKOuaOfUMUIw=
MIME-Version: 1.0
In-Reply-To: <AANLkTikKf1XnbWXm6TqSeQe_fUVjeSR0J8DTvcEy3xcP@mail.gmail.com>
References: <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>
	<4CBAE8E2.1060704@redhat.com>
	<AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>
	<4CBBF3C8.9070104@web.de>
	<4CBC1047.6010501@redhat.com>
	<20101018125803.GA2497@darkstar>
	<4CBC4B06.3030300@redhat.com>
	<20101018134508.GA11885@darkstar>
	<4CBC4FA9.90406@redhat.com>
	<4CBC5097.1020105@redhat.com>
	<20101018135813.GA20316@darkstar>
	<4CBC547A.8080700@redhat.com>
	<AANLkTi=htiXrjAnQcm7=Rha+PYQA7iibn3WFRzyx_Owq@mail.gmail.com>
	<4CBC55FB.30205@redhat.com>
	<AANLkTikKf1XnbWXm6TqSeQe_fUVjeSR0J8DTvcEy3xcP@mail.gmail.com>
Date: Mon, 18 Oct 2010 22:17:05 +0800
Message-ID: <AANLkTi=JJHfw4fvL+RjBkJ0UuSD_j1eiTMj2Bc7_bAHC@mail.gmail.com>
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
From: Dave Young <hidave.darkstar@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 10:15 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Mon, Oct 18, 2010 at 10:13 PM, Avi Kivity <avi@redhat.com> wrote:
>>  On 10/18/2010 04:11 PM, Dave Young wrote:
>>>
>>> On Mon, Oct 18, 2010 at 10:06 PM, Avi Kivity<avi@redhat.com>  wrote:
>>> >    On 10/18/2010 03:58 PM, Dave Young wrote:
>>> >>
>>> >>  >
>>> >>  >    Please patch hardware_setup() to show the value of
>>> >>  >    boot_cpu_has(X86_FEATURE_NX).
>>> >>
>>> >>  It's 0
>>>
>>> Please wait, I reply too quick, actually it boots two times fine then
>>> one time fail.
>>
>> What boots fine?  The guest?
>
> Yes the guest
>
>>
>>> The printk only happen once. So to make sure the result I retested
>>> several times, can not get the print as well.
>>
>> boot_cpu_has() is called only when the kvm module is inserted.
>
> Oh, then I need to test again.

I'm lucky, this time I can make sure has_nx = 0

after insmod, guest boot failed at the first test
>
>>
>> --
>> error compiling committee.c: too many arguments to function
>>
>>
>
>
>
> --
> Regards
> dave
>



-- 
Regards
dave
