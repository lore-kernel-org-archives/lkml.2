Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1KIHlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 02:41:35 -0500
Received: from dalsmrelay2.nai.com ([205.227.136.216]:54077 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1KIHle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 02:41:34 -0500
Message-ID: <4EBA2DC5.5010907@snapgear.com>
Date: Wed, 9 Nov 2011 17:37:41 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the m68knommu tree with the m68k
 tree
References: <20111109111519.7d8969103ab32e7e8193c018@canb.auug.org.au>	<4EBA26D9.3050108@snapgear.com> <CAMuHMdVsE4ZY3p8+kPgmKe5OOpoi1QV6BASK7gFYYTUDezyzLA@mail.gmail.com>
In-Reply-To: <CAMuHMdVsE4ZY3p8+kPgmKe5OOpoi1QV6BASK7gFYYTUDezyzLA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 11/09/2011 05:13 PM, Geert Uytterhoeven wrote:
> Hi Greg,
>
> On Wed, Nov 9, 2011 at 08:08, Greg Ungerer<gerg@snapgear.com>  wrote:
>> On 11/09/2011 10:15 AM, Stephen Rothwell wrote:
>>> Today's linux-next merge of the m68knommu tree got a conflict in
>>> arch/m68k/Kconfig between commit d890d7399525 ("m68k/irq: Remove obsolete
>>> m68k irq framework") from the m68k tree and commit 4e8a9e70dfe8 ("m68k:
>>> selection of GENERIC_ATOMIC64 is not MMU specific") from the m68knommu
>>> tree.
>>>
>>> Just context changes. áI fixed it up (see below) and can carry the fix as
>>> necessary.
>>
>> Thanks. Both this and the previous m68k merge conflict patch look good.
>>
>> Geert: would you prefer I hold off on these 2 patches until after
>> you merge your IRQ changes?
>
> I'll ask Linus to pull them today or tomorrow. After that (and he has
> pulled), you can
> rebase your tree. Is that OK for you?

Yep, that is good. I wasn't sure if you where looking to push them
in rc1 or in the next merge window.

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
