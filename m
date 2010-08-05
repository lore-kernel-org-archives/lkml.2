Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab0HEBK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 21:10:26 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39029 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab0HEBKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 21:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZT9M8uzx0mAA0KIPhhP7KJ/zL1MpTBqLFeDWNfGQ+sXiR0xtZLMG5E9zE+4cEkpSDR
         73q7pV4R9FbeQt33W+h2VosbJMOU2Kop9d9sn5ZwNSU2Llum4pS2I6dqznjuK9QW3Z5d
         7vq00VR6D3JQhmjlTDJwYkTHMjg5ZHb16JfXA=
MIME-Version: 1.0
In-Reply-To: <AANLkTimejYX3OEk9j+L+nWKyBuf7=rJbAOvQGhxJNPxN@mail.gmail.com>
References: <AANLkTi=1DxqLrqVbfRouOBRWg4RHFaHz438X7F1JWL6P@mail.gmail.com>
	<AANLkTimejYX3OEk9j+L+nWKyBuf7=rJbAOvQGhxJNPxN@mail.gmail.com>
Date: Thu, 5 Aug 2010 09:10:21 +0800
Message-ID: <AANLkTi=5Ks0jmnGgUzH_gPEt36KPK7mwfdMscw8yTPmc@mail.gmail.com>
Subject: Re: question about CONFIG_BASE_SMALL
From: Pei Lin <telent997@gmail.com>
To: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Cc: Ryan Wang <openspace.wang@gmail.com>, kernelnewbies@nl.linux.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/4 Mulyadi Santosa <mulyadi.santosa@gmail.com>:
> Hi...
>
> On Wed, Aug 4, 2010 at 15:38, Ryan Wang <openspace.wang@gmail.com> wrote:
>> Hi all,
>>
>>      I noticed CONFIG_BASE_SMALL in different parts
>> of the kernel code, with ifdef/ifndef.
>>      I wonder what does CONFIG_BASE_SMALL mean?
>> And how can I configure it, e.g. through make menuconfig?
>
> Reply on top of my head: IIRC it means to disable certain things...or
> possibly enabling things that might reduce memory footprints.
>
> The goal....to make Linux kernel running more suitable for embedded
> system and low level specification machine...
>
FYI.

Date:	Mon, 31 Jan 2005 01:25:51 -0600
To: Andrew Morton <akpm@osdl.org>

This patch series introduced a new pair of CONFIG_EMBEDDED options call
CONFIG_BASE_FULL/CONFIG_BASE_SMALL. Disabling CONFIG_BASE_FULL sets
the boolean CONFIG_BASE_SMALL to 1 and it is used to shrink a number
of core data structures. The space savings for the current batch is
around 14k.
-

For example , look at the file "Linux/include/linux/udp.h"
http://lxr.free-electrons.com/source/include/linux/udp.h

#define UDP_HTABLE_SIZE_MIN             (CONFIG_BASE_SMALL ? 128 : 256)


> --
> regards,
>
> Mulyadi Santosa
> Freelance Linux trainer and consultant
>
> blog: the-hydra.blogspot.com
> training: mulyaditraining.blogspot.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Best Regards
Lin
