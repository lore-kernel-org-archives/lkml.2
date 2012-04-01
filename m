Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab2DAFSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 01:18:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60127 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2DAFSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 01:18:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAOzFzEjJSuTKy9-wk-qSzsmMHfB8h2ushRG6LQ0+92uDyB4sZg@mail.gmail.com>
References: <CA+ekxPWHbOsa1BChpPvr4Bzj=8YixLDWA2TWtRyHSQ43QqVdqw@mail.gmail.com>
	<1333221304.30812.5.camel@obelisk.thedillows.org>
	<CA+ekxPUP+6DbYS6u-fvrKB0awiaL=WQBW7TF5u-XFSehWuM7Ag@mail.gmail.com>
	<CAOzFzEjJSuTKy9-wk-qSzsmMHfB8h2ushRG6LQ0+92uDyB4sZg@mail.gmail.com>
Date: Sat, 31 Mar 2012 23:18:17 -0600
Message-ID: <CA+ekxPX90hgC80HdHvy4U31fdM8gd1sRdSoa1osPpwgwNH-jmw@mail.gmail.com>
Subject: Re: [ANNOUNCE] Linux hits 20 Gb/s stream to disk levels over Infiniband
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Joseph Glanville <joseph.glanville@orionvm.com.au>
Cc: David Dillow <dave@thedillows.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/31/12, Joseph Glanville <joseph.glanville@orionvm.com.au> wrote:
> On 1 April 2012 05:23, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
>> On 3/31/12, David Dillow <dave@thedillows.org> wrote:
>>> On Sat, 2012-03-31 at 11:28 -0600, Jeffrey Merkey wrote:
>>>> Made it to 20 Gb/s network packet capture stream to disk performance
>>>> levels over Infiniband fabrics on Linux.
>>>
>>> I'm assuming that the interesting part is the 20 Gbits/s capture? And at
>>> minimum packet sizes, I'd hope. Linux has been able to stream more than
>>> 5 GBytes/s (40 Gbits/s) to disk for several years now over SRP.
>>
>> Network Capture while being routed and regenerated and piped through
>> apps at the same time from live network traffic.  Most of the other
>> vendors tout 10 Gb/s stream to disk but only Solera really can do it.
>> All of them except Niksun are Linux and I think they moved some of
>> their stuff to it.  So hitting 20 Gb/s is a big deal right now.  With
>> Intel's push in IB/Ethernet, this is where the next thing is going.
>> 3D Torus stuff is totally cool.  You can actually store data in the
>> network itself.  Talk about a challenge for Network security.
>
> You can do Infiniband routing in software? This is indeed very interesting.
> Pinged your contact page. :)

Got your email.  Was catching up on SLES testing today, so sorry for
the late response.     Yes, we can support IP routing and regeneration
over IB fabrics.  If your question is can we also support native
routing of some IB functionality, yes.   But RDMA stuff is better left
direct without local store and forward in software.    I will email
you off line and you can better describe what you want done on IB.
The api and ib verbs are tedious and detailed to
program, but the technology rocks.  We use IB primarily as an IP and
storage fabric, but I have worked on several commercial products with
IB, notably, this one last year which does routing -- a ton of work.
www.kove.com

Jeff

>
>>
>> The next class of malicious programs may be adapted to live within
>> fabrics and require new methods to detect and remove them.
>>
>>>
>>>>  Will be trying this on 3.0
>>>> after I work through the OFED issues (long list).  Post the results
>>>> from 3.0.  These are from 2.6.XX series kernels.
>>>
>>> You may find it easier to use a recent RedHat or SUSE with an upstream
>>> kernel. I know that RHEL6 userland is compatible with the upstream
>>> kernel's Infiniband, and OFED is moving its kernel work to a "backport
>>> upstream" model for OFED 3.2.
>>>
>>
>>
>> I've got RH6 done, but OFED was down on the list and SLES was ahead
>> of.it.  No rest for the weary.
>>
>> Jeff
>>
>>>> Linux f_cking ROCKS!!!
>>>
>>> Indeed it does.
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> Joseph.
>
> --
> Founder | Director | VP Research
> Orion Virtualisation Solutions | www.orionvm.com.au | Phone: 1300 56
> 99 52 | Mobile: 0428 754 846
>
