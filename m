Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1FWGNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:13:19 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:15800 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1FWGNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:13:18 -0400
Message-ID: <4E02D939.7090206@snapgear.com>
Date: Thu, 23 Jun 2011 16:12:09 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: manual merge of the m68knommu tree with the m68k
 tree
References: <20110622111256.3857df1e.sfr@canb.auug.org.au>	<4E018CE3.7070101@snapgear.com> <BANLkTinswxRuM52vW7acZrsKgpMrSxMuWA@mail.gmail.com>
In-Reply-To: <BANLkTinswxRuM52vW7acZrsKgpMrSxMuWA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/06/11 18:29, Geert Uytterhoeven wrote:
> Hi Greg, Stephen,
>
> On Wed, Jun 22, 2011 at 08:34, Greg Ungerer<gerg@snapgear.com>  wrote:
>> On 22/06/11 11:12, Stephen Rothwell wrote:
>>> Today's linux-next merge of the m68knommu tree got a conflict in
>>> arch/m68k/include/asm/bitops_mm.h between commit 17c74432b88e
>>> ("m68k/bitops: Make bitmap data pointer of atomic ops volatile") from the
>>> m68k tree and commit 2cb0d89e66b1 ("m68k: merge mmu and non-mmu
>>> bitops.h") from the m68knommu tree.
>>>
>>> The latter effectively deletes in the file and in doing the merge,
>>> removes the funtions that were modified by the former commit. áSo I just
>>> removed the file.
>>
>> That would be right. The changes that Geert's patch makes are in
>> my merge patch.
>
> Sorry, I forgot that Greg was merging them, which also fixes the issue we
> had on m68k.
>
> [mental note to self: check for merge conflicts with m68knommu before updating
>   for-next]
>
>> Geert: do you want me to hold of on merging the bitops.h files?
>
> No, it looks fine to me. Feel free to add my Acked-by.

Thanks Geert. Will do.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
