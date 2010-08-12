Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab0HLBgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 21:36:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47540 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373Ab0HLBgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 21:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=tPeca2R9l92zJpvGSO0IhMXRDjP32BQXyJydNbUdeN/Fs+Of0ITVTKlduxrtb0zUUj
         xJxi1YAzkuSjfEqSOFMVly3Dg1wQSsrU3GfttcasA0uwSIIHeQg3Cghet96jDquaZc6w
         VzxcusYzZWmTWMkISJ8EquUC3Qi5/yedZLFec=
MIME-Version: 1.0
In-Reply-To: <4C62F4BD.9030605@vmware.com>
References: <AANLkTi=4_QnAyY+zcuXwVpPkESjpF7yfMb1RunMQaK7f@mail.gmail.com> 
	<1281553430.32376.2.camel@hactar> <4C62F4BD.9030605@vmware.com>
From: Hui Zhu <teawater@gmail.com>
Date: Thu, 12 Aug 2010 09:35:46 +0800
Message-ID: <AANLkTimrqy1+hbZY7p2XuY2fXYy4PUAd6i4-kfoqjfKe@mail.gmail.com>
Subject: Re: Linux Kernel GDB tracepoint module demo release
To: Michael Snyder <msnyder@vmware.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>
Cc: "gdb@sourceware.org" <gdb@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Thiago and Michael, both of them have some limit.  I try to
make gdb tracepoint and kernel work together directly. :)

Thanks,
Hui


On Thu, Aug 12, 2010 at 03:06, Michael Snyder <msnyder@vmware.com> wrote:
> Thiago Jung Bauermann wrote:
>>
>> Hi Hui,
>>
>> On Thu, 2010-08-12 at 00:34 +0800, Hui Zhu wrote:
>>>
>>> GDB Tracepoint
>>> (http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html)
>>> is new feature that make GDB can debug real-time program.
>>> I think this feature is very fit for debug Linux Kernel.  So I make a
>>> lkm to make kernel support it. You can get it in
>>> https://code.google.com/p/kgtp/
>>
>> Jim Blandy worked on GDB tracepoint support for the kernel too. I don't
>> know how his work compares to yours, you might be interested in having a
>> look:
>>
>> http://www.red-bean.com/trac/tracepoints/
>>
>
> There's also the LTTng project: http://lttng.org/
>
>
>
