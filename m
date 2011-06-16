Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab1FPJ4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:56:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62888 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab1FPJ4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:56:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110616094737.GB5583@const.bordeaux.inria.fr>
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
	<20110616085547.GH4935@const.famille.thibault.fr>
	<BANLkTinxz1T7uPAS0u=gth3hAh+SFQkTQQ@mail.gmail.com>
	<20110616094737.GB5583@const.bordeaux.inria.fr>
Date: Thu, 16 Jun 2011 11:56:03 +0200
Message-ID: <BANLkTin2F-sJNjrMhTTqrh0J3ej9OVvQxA@mail.gmail.com>
Subject: Re: [RFC] Add Arm cpu topology definition
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Cc: Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2011 11:47, Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> Vincent Guittot, le Thu 16 Jun 2011 11:44:30 +0200, a écrit :
>> The output of hwloc-gather-topology is :
>>
>> Machine (phys=0 local=280840KB total=280840KB)
>>   Socket #0 (phys=3)
>>     Core #0 (phys=0)
>>       PU #0 (phys=0)
>>     Core #1 (phys=1)
>>       PU #1 (phys=1)
>> depth 0:        1 Machine (type #1)
>>  depth 1:       1 Socket (type #3)
>>   depth 2:      2 Cores (type #5)
>>    depth 3:     2 PUs (type #6)
>> Topology not from this system
>>
>> let me know if it's what you want
>
> This looks good for a bicore socket, yes.  Could you send me the tarball
> it created, so we can include it in the hwloc testsuite?
>

yes, I will send it to you

> Do you have a example with smt cores?

no, I haven't

>
> Samuel
>
