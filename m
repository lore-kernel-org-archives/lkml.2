Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233Ab1LFQAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:00:17 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:52204 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750804Ab1LFQAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:00:15 -0500
Message-ID: <4EDE49EE.4060909@xenotime.net>
Date: Tue, 06 Dec 2011 08:59:26 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>, Joerg Roedel <joro@8bytes.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd_iommu: Fix typo in kernel-parameters.txt
References: <1323122912-14532-1-git-send-email-sedat.dilek@gmail.com>	<20111206141735.GN20535@8bytes.org> <CA+icZUXFT0bC8x-3E96sYya_ayiLvKMM4s7kR3J2XAh6C9tQdw@mail.gmail.com>
In-Reply-To: <CA+icZUXFT0bC8x-3E96sYya_ayiLvKMM4s7kR3J2XAh6C9tQdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 06:20 AM, Sedat Dilek wrote:
> On Tue, Dec 6, 2011 at 3:17 PM, Joerg Roedel <joro@8bytes.org> wrote:
>> On Mon, Dec 05, 2011 at 11:08:32PM +0100, Sedat Dilek wrote:
>>>
>>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>>> ---
>>>  Documentation/kernel-parameters.txt |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>>> index a0c5c5f..da50377 100644
>>> --- a/Documentation/kernel-parameters.txt
>>> +++ b/Documentation/kernel-parameters.txt
>>> @@ -320,7 +320,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>>                       on: enable for both 32- and 64-bit processes
>>>                       off: disable for both 32- and 64-bit processes
>>>
>>> -     amd_iommu=      [HW,X86-84]
>>> +     amd_iommu=      [HW,X86-64]
>>>                       Pass parameters to the AMD IOMMU driver in the system.
>>>                       Possible values are:
>>>                       fullflush - enable flushing of IO/TLB entries when
>>
>> Applied, thanks. Please Cc me directly on future patches so it is easier
>> to notice for me :)
> 
> Sorry for this, I followed stupidly get_maintainer.pl script :-).

Not a problem -- I would have applied it soon.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
