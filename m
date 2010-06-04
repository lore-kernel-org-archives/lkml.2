Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0FDNzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 09:55:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38279 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab0FDNzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 09:55:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IWNpdlYYYCJe4xx1u4LDMR7I4TlfUzSOwYIWAXYBaBJ4nrsvQo40GevszjdvmIaJao
         mn22OnPktWJQIR5a4NV4pjhVjR/qvI05kOozdH1NsGkGWJRb7Y7Cul4kfHsFptb+g6QN
         heuj8i47m4Z4zI4U4Ylp2B99GMlu2CnMa1qVQ=
MIME-Version: 1.0
In-Reply-To: <tnxvd9zcbr9.fsf@e102109-lin.cambridge.arm.com>
References: <AANLkTilb4QNYznFeJVfMmvPAlBY-B02EY0i0d7NK9X7O@mail.gmail.com>
	<tnxvd9zcbr9.fsf@e102109-lin.cambridge.arm.com>
Date: Fri, 4 Jun 2010 21:55:05 +0800
Message-ID: <AANLkTillFhDzhz06IXArHKbZCy9zBI5Isl4c2DiROXlz@mail.gmail.com>
Subject: Re: mmotm 2010-06-03-16-36 lots of suspected kmemleak
From: Dave Young <hidave.darkstar@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 6:50 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> Dave Young <hidave.darkstar@gmail.com> wrote:
>> With mmotm 2010-06-03-16-36, I gots tuns of kmemleaks
>
> Do you have CONFIG_NO_BOOTMEM enabled? I posted a patch for this but
> hasn't been reviewed yet (I'll probably need to repost, so if it fixes
> the problem for you a Tested-by would be nice):
>
> http://lkml.org/lkml/2010/5/4/175


I'd like to test, but I can not access the test pc during weekend. So
I will test it next monday.

For CONFIG_NO_BOOTMEM, I don't remember. I guess set as 'y'
>
> Thanks.
>
> --
> Catalin
>

-- 
Regards
dave
