Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab0JROPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:15:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47454 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab0JROPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gm7y7uGC710zCMTT7u4WAk+Z7bm3QMf2v0XjL/vrtghv4g4c23f/MxI2BAzDENoRCh
         /zF81vsIzp7NDI2/VX7UeXlKOguK+0l4if4DRp/Pu0dkOlWgt8RrHQc2NRUwnxnI33hj
         U2Wjeo91w39H9H5OXQtMNwdB2hzVickui4/c0=
MIME-Version: 1.0
In-Reply-To: <4CBC55FB.30205@redhat.com>
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
Date: Mon, 18 Oct 2010 22:15:05 +0800
Message-ID: <AANLkTikKf1XnbWXm6TqSeQe_fUVjeSR0J8DTvcEy3xcP@mail.gmail.com>
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

On Mon, Oct 18, 2010 at 10:13 PM, Avi Kivity <avi@redhat.com> wrote:
>  On 10/18/2010 04:11 PM, Dave Young wrote:
>>
>> On Mon, Oct 18, 2010 at 10:06 PM, Avi Kivity<avi@redhat.com>  wrote:
>> >    On 10/18/2010 03:58 PM, Dave Young wrote:
>> >>
>> >>  >
>> >>  >    Please patch hardware_setup() to show the value of
>> >>  >    boot_cpu_has(X86_FEATURE_NX).
>> >>
>> >>  It's 0
>>
>> Please wait, I reply too quick, actually it boots two times fine then
>> one time fail.
>
> What boots fine?  The guest?

Yes the guest

>
>> The printk only happen once. So to make sure the result I retested
>> several times, can not get the print as well.
>
> boot_cpu_has() is called only when the kvm module is inserted.

Oh, then I need to test again.

>
> --
> error compiling committee.c: too many arguments to function
>
>



-- 
Regards
dave
