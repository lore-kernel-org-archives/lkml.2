Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab1LFOUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:20:35 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:42591 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308Ab1LFOUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:20:32 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20111206141735.GN20535@8bytes.org>
References: <1323122912-14532-1-git-send-email-sedat.dilek@gmail.com>
	<20111206141735.GN20535@8bytes.org>
Date: Tue, 6 Dec 2011 15:20:31 +0100
Message-ID: <CA+icZUXFT0bC8x-3E96sYya_ayiLvKMM4s7kR3J2XAh6C9tQdw@mail.gmail.com>
Subject: Re: [PATCH] amd_iommu: Fix typo in kernel-parameters.txt
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 3:17 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Mon, Dec 05, 2011 at 11:08:32PM +0100, Sedat Dilek wrote:
>>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>> ---
>>  Documentation/kernel-parameters.txt |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index a0c5c5f..da50377 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -320,7 +320,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>                       on: enable for both 32- and 64-bit processes
>>                       off: disable for both 32- and 64-bit processes
>>
>> -     amd_iommu=      [HW,X86-84]
>> +     amd_iommu=      [HW,X86-64]
>>                       Pass parameters to the AMD IOMMU driver in the system.
>>                       Possible values are:
>>                       fullflush - enable flushing of IO/TLB entries when
>
> Applied, thanks. Please Cc me directly on future patches so it is easier
> to notice for me :)

Sorry for this, I followed stupidly get_maintainer.pl script :-).

- Sedat -
