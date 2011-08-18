Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab1HRL7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:59:30 -0400
Received: from lucidpixels.com ([72.73.18.11]:35496 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584Ab1HRL71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:59:27 -0400
Date: Thu, 18 Aug 2011 07:59:26 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: 3.1-rc2: CONFIG_NUMA Question
In-Reply-To: <CAM_iQpWPaavsa7gSURP5CL8+Es2P5rEdtLRmrOx+wQkThX7v9w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1108180758290.7903@p34.internal.lan>
References: <alpine.DEB.2.02.1108180649040.10458@p34.internal.lan> <CAM_iQpWPaavsa7gSURP5CL8+Es2P5rEdtLRmrOx+wQkThX7v9w@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1330709977-1313668766=:7903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-1330709977-1313668766=:7903
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Thu, 18 Aug 2011, Am=C3=A9rico Wang wrote:

> On Thu, Aug 18, 2011 at 6:51 PM, Justin Piszcz <jpiszcz@lucidpixels.com> =
wrote:
>> Hi,
>>
>> I have a SuperMicro X8DTH-6F motherboard with 2 cpus it has NUMA options=
 in
>> the BIOS; what parameters/should I be using for the NUMA options in the
>> kernel?
>>
>> =C2=A0| | =C2=A0 =C2=A0[*] Numa Memory Allocation and Scheduler Support =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | |
>> =C2=A0| | =C2=A0 =C2=A0[ ] Old style AMD Opteron NUMA detection =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | |
>> =C2=A0| | =C2=A0 =C2=A0[*] ACPI NUMA detection =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| |
>> =C2=A0| | =C2=A0 =C2=A0[ ] NUMA emulation =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | |
>> =C2=A0| | =C2=A0 =C2=A0(6) Maximum NUMA Nodes (as a power of 2) =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | |
>>
>
> That is Intel processor, right? If so, the things you selected here are e=
nough,
Hi, yes-- two Intel Xeon E5645s.

> the rest two is not what you need.
Ok.

>
>> Specifically, the maximum number of NUMA nodes? =C2=A0Will this help to =
increase
>> performance of large memory allocations/is there any downside
>> to enabling this feature?
>
> The max of NUMA nodes is specified by CONFIG_NODES_SHIFT,
> in your case, it is 6, which means it supports up to 2^6 nodes.
Ok, is there any overhead having more than is needed?

>
> If your hardware supports NUMA, yes, that certainly help to increase
> the performance.
Nice, thanks.

Justin.

--655872-1330709977-1313668766=:7903--
