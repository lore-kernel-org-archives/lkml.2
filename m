Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab1EZAWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 20:22:40 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:41150 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab1EZAWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 20:22:38 -0400
Message-ID: <4DDD9C8A.3000104@snapgear.com>
Date: Thu, 26 May 2011 10:19:22 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: Re: linux-next: manual merge of the m68knommu tree with Linus' tree
References: <20110525110424.0f3dbe85.sfr@canb.auug.org.au>
In-Reply-To: <20110525110424.0f3dbe85.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 25/05/11 11:04, Stephen Rothwell wrote:
> Hi Greg,
>
> Today's linux-next merge of the m68knommu tree got a conflict in
> arch/m68k/kernel/m68k_ksyms.c between commit a697dc934f52 ("m68k: merge
> non-mmu and mmu versions of m68k_ksyms.c") from Linus' tree and commit
> e05f64c1bac9 ("m68k: merge non-mmu and mmu versions of m68k_ksyms.c")
> from the m68knommu tree.
>
> Two (slightly different) versions of the same change  I used the version
> from the m68knommu tree as that was comitted later.

Sorry, should be fixed now. (Though maybe I annoyed Andrew a little
by including a couple of new patches in there as well :-(


> P.S. Greg, do I need to change your contact address?

No, you can use any of:

   gerg@snapgear.com
   gerg@uclinux.org

I tend to signoff using the uclinux.org address, but primary email
address is the snapgear.com one.

Regards
Greg


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
