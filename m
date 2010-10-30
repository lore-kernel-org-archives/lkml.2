Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab0J3JWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 05:22:13 -0400
Received: from smtp.tele.fi ([192.89.123.25]:45601 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab0J3JWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 05:22:12 -0400
X-Originating-Ip: [194.89.68.22]
Date: Sat, 30 Oct 2010 12:21:58 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: "Singapore Citizen Mr. Teo En Ming (Zhang Enming) ????????? " 
	<space.time.universe@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "teoenming@hotmail.com" <teoenming@hotmail.com>,
        zhang_enming@lavabit.com
Subject: Re: Linux Kernel 2.6.36 Status
Message-ID: <20101030092158.GS2804@reaktio.net>
References: <4C95BC88.9050301@gmail.com> <20101004122752.GZ2804@reaktio.net> <4CCBA5C5.2050505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CCBA5C5.2050505@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 12:57:41PM +0800, "Singapore Citizen Mr. Teo En Ming (Zhang Enming) ????????? " wrote:
> On 10/04/2010 08:27 PM, Pasi Kärkkäinen wrote:
>> On Sun, Sep 19, 2010 at 03:32:24PM +0800, "Mr. Teo En Ming (Zhang Enming) ????????? of Singapore" wrote:
>>    
>>> Dear Linus Torvalds,
>>>
>>> May I know if Linux kernel 2.6.36 is Xen pv-ops dom0 ready?
>>>
>>>      
>> Linux 2.6.36 will not contain pv-ops dom0 code.
>>
>> The RFC request about initial dom0 patches was sent recently,
>> and once reviewd/ack'd, the code can go into later kernel version.
>>
>> -- Pasi
>>
>>    
>>> Thank you very much.
>>>
>
> Dear Pasi,
>
> Later Linux kernel versions as in 2.6.37, or 2.6.38?
>
> Thank you very much.
>

core/initial xen pvops dom0 patches were merged to 2.6.37.

There's still more to merge/upstream, like xen backend drivers,
to be able to run other domains using the upstream kernel.

-- Pasi

