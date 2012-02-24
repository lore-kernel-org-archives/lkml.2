Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab2BXLQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:16:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50978 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab2BXLQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:16:06 -0500
Message-ID: <4F477171.8010605@ti.com>
Date: Fri, 24 Feb 2012 12:16:01 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Aneesh V <aneesh@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 4/8] misc: emif: add basic infrastructure for EMIF
 driver
References: <1328357771-31644-1-git-send-email-aneesh@ti.com> <1328357771-31644-5-git-send-email-aneesh@ti.com> <4F3D2F2F.8050406@ti.com> <4F47701C.2090305@ti.com>
In-Reply-To: <4F47701C.2090305@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/2012 12:10 PM, Aneesh V wrote:
> On Thursday 16 February 2012 10:00 PM, Cousson, Benoit wrote:
>> Hi Aneesh,
>>
>
> [...]
>
>>> +struct emif_data {
>>> + u8 duplicate;
>>> + u8 temperature_level;
>>> + u32 irq;
>>> + spinlock_t lock; /* lock to prevent races */
>>
>> Nit: That comment is useless, since you already have the kerneldoc
>> comment before.
>
> Now I remember why I did that. Without that comment checkpatch gives
> this "check".
>
> CHECK: spinlock_t definition without comment
> #124: FILE: drivers/misc/emif.c:54:
> + spinlock_t lock;

That's a pretty interesting comment :-)
I guess checkpatch should be able to check for a potential kerneldoc as 
well. You might want to report that to the checkpatch maintainer.

Thanks,
Benoit
