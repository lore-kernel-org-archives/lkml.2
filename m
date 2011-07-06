Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1GFXpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:45:36 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:44329 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab1GFXpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:45:33 -0400
Message-ID: <4E14F373.1020307@snapgear.com>
Date: Thu, 7 Jul 2011 09:44:51 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jonas Bonn <jonas@southpole.se>, Rusty Russell <rusty@rustcorp.com.au>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: manual merge of the rr tree with the  tree
References: <20110705135932.de7f0526.sfr@canb.auug.org.au> <1309967847.3393.44.camel@jerome>
In-Reply-To: <1309967847.3393.44.camel@jerome>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/11 01:57, Jonas Bonn wrote:
>
> On Tue, 2011-07-05 at 13:59 +1000, Stephen Rothwell wrote:
>> Hi Rusty,
>>
>> Today's linux-next merge of the rr tree got a conflict in
>> arch/m68k/kernel/module_mm.c arch/m68k/kernel/module_no.c between commit
>> 4528acce2607 ("m68k: merge the non-mmu and mmu versions of module.c")
>> from the m68knommu tree and commit 7b935befe6bc ("modules: make arch's
>> use default loader hooks") from the rr tree.
>>
>> The former removes these files, so I did that.
>>
>> I then added this merge fix up patch (which I can carry as necessary and
>> may not be coorrect):
>>
>> From: Stephen Rothwell<sfr@canb.auug.org.au>
>> Date: Tue, 5 Jul 2011 13:12:26 +1000
>> Subject: [PATCH] modules/m68k: make arch's use default loader hooks
>>
>> Signed-off-by: Stephen Rothwell<sfr@canb.auug.org.au>
>> ---
>>   arch/m68k/kernel/module.c |   27 ---------------------------
>>   1 files changed, 0 insertions(+), 27 deletions(-)
>>
>
> That patch looks good to me.
>
> Acked-by: Jonas Bonn<jonas@southpole.se>

Looks fine to me too:

Acked-by: Greg Ungerer <gerg@uclinux.org>

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
