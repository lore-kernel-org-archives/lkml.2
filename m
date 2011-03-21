Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1CUMg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:36:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64804 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1CUMg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:36:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rBYO23ASATBsIPBS6ZJ1ehy9d8uZ5XGSNDd4UERZk1BkHQfmzylxSkLB5Hd18iJxVB
         jbbNFdSPPtHgRS9gWXlDUE8aDAoXDWK8apkYBkq4UeU632cC2MPdCwOqEzxUH3vmP2oP
         3H5CMP9wmZfEINFFfxUD8B1VPEAv1vGGUQqRY=
MIME-Version: 1.0
In-Reply-To: <20110124214225.GO24104@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	<1295891761-18366-9-git-send-email-catalin.marinas@arm.com>
	<AANLkTi=d0q0Upde3=b4tpu3icOr4XdifcFRvBHuXgsBN@mail.gmail.com>
	<20110124214225.GO24104@n2100.arm.linux.org.uk>
Date: Mon, 21 Mar 2011 12:36:55 +0000
X-Google-Sender-Auth: 3ceKl3vIpWxYPHhEOxgtpBOtI9E
Message-ID: <AANLkTikH9tBTGCiJ-+dvhh1tajMVq_6ua41MMZmq48sC@mail.gmail.com>
Subject: Re: [PATCH v4 08/19] ARM: LPAE: Introduce the 3-level page table
 format definitions
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nick Piggin <npiggin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 24 January 2011 21:42, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Jan 25, 2011 at 08:26:42AM +1100, Nick Piggin wrote:
>> Too bad about the PAE thing; my condolences.
>>
>>
>> On Tue, Jan 25, 2011 at 4:55 AM, Catalin Marinas
>> <catalin.marinas@arm.com> wrote:
>> > This patch introduces the pgtable-3level*.h files with definitions
>> > specific to the LPAE page table format (3 levels of page tables).
>>
>> Seeing as you're shaking up these definitions, what do you think about
>> switching from 4level-fixup.h to pgtable-nopud.h / pgtable-nopmd.h headers?
>> One day eventually it would be nice to get rid of the fixup mode.
>
> I have patches to do this which I de-queued for the last merge window.
> It's not entirely trivial and without problem.  You can find the patches
> in linux-next now.
>
> I was waiting for the new set of patches from Catalin before going back
> and working out the solutions to some of those problems.

Any plans for the nopmd patches? I haven't seen them in -next or on the list.

Thanks.

-- 
Catalin
