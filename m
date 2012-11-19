Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2KSG7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:59:44 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:46037 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2KSG7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:59:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Nov 2012 08:59:37 +0200
From: Denys Fedoryshchenko <denys@visp.net.lb>
To: David Rientjes <rientjes@google.com>
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Michael Chan <mchan@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Latest 3.6.6 are not compiling due tg3 network driver,
 =?UTF-8?Q?hwmon=5Fdevice=5Funregister?=
In-Reply-To: <alpine.DEB.2.00.1211181441470.5080@chino.kir.corp.google.com>
References: <8b566c4a9ee622737212dc17291ee238@visp.net.lb>
 <50A4606D.4020402@broadcom.com>
 <alpine.DEB.2.00.1211141929510.14414@chino.kir.corp.google.com>
 <50A464E4.1080105@broadcom.com>
 <alpine.DEB.2.00.1211181441470.5080@chino.kir.corp.google.com>
Message-ID: <d7418ec9ab1ae59a0ce5a101c6ff55e1@visp.net.lb>
User-Agent: VISP Webmail/0.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-19 00:42, David Rientjes wrote:
> On Wed, 14 Nov 2012, Nithin Nayak Sujir wrote:
>
>> On 11/14/2012 07:30 PM, David Rientjes wrote:
>> > On Wed, 14 Nov 2012, Nithin Nayak Sujir wrote:
>> >
>> > > This was fixed by
>> > >
>> > > commit de0a41484c47d783dd4d442914815076aa2caac2
>> > > Author: Paul Gortmaker <paul.gortmaker@windriver.com>
>> > > Date:   Mon Oct 1 11:43:49 2012 -0400
>> > >
>> > >      tg3: unconditionally select HWMON support when tg3 is 
>> enabled.
>> > >
>> > Would you mind submitting this for stable by following the 
>> procedure
>> > described in Documentation/stable_kernel_rules.txt?
>> >
>>
>> Will do. Thank you for bringing this to our attention.
>>
>
> Thanks for submitting the patch to stable, Greg has queued it for the
> kernels he maintains.  Denys, expect to see this fix in 3.6.8.
Thank you!

---
Denys Fedoryshchenko, Network Engineer, Virtual ISP S.A.L.
