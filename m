Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab1CBVyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:54:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34425 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab1CBVyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:54:13 -0500
MIME-Version: 1.0
In-Reply-To: <4D6EBB3A.3040108@gmail.com>
References: <AANLkTimvaSwM0NmjWEC0S=uRCdc6MmSzB-3xqhTV7Y=y@mail.gmail.com> <4D6EBB3A.3040108@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 2 Mar 2011 14:53:53 -0700
X-Google-Sender-Auth: B-QIzPcLeVfW_klOu37dm93y7AI
Message-ID: <AANLkTin3CAukvZVvjwM6q-p8cPsJ1xLwiD5=0Gs7yXtq@mail.gmail.com>
Subject: Re: [git pull] device tree bug fixes
To: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 2:48 PM, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> On 03/02/2011 01:38 PM, Grant Likely wrote:
>>
>> Hi Linus,
>>
>> A few more patches for .28
>
>                          ^^
> Are you pining for an old release :-)

Gah!  .38!  .38!  <grumble stupid big numbers>

g.

>
> --Dirk
>>
>> The following changes since commit
>> dd9c1549edef02290edced639f67b54a25abbe0e:
>>
>>   Linux 2.6.38-rc7 (2011-03-01 13:55:12 -0800)
>>
>> are available in the git repository at:
>>   git://git.secretlab.ca/git/linux-2.6 devicetree/merge
>>
>> Andres Salomon (2):
>>       x86: OLPC: have prom_early_alloc BUG rather than return NULL
>>       of/promtree: allow DT device matching by fixing 'name' brokenness
>> (v5)
>>
>> Michal Simek (1):
>>       of: Add missing of_address.h to xilinx ehci driver
>>
>> Paul Bolle (1):
>>       of/flattree: Drop an uninteresting message to pr_debug level
>>
>>  arch/x86/platform/olpc/olpc_dt.c  |    3 +-
>>  drivers/of/pdt.c                  |  112
>> ++++++++++++++-----------------------
>>  drivers/usb/host/ehci-xilinx-of.c |    1 +
>>  fs/proc/proc_devtree.c            |    2 +-
>>  4 files changed, 45 insertions(+), 73 deletions(-)
>>
>>
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
