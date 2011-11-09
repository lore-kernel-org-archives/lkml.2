Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1KIHIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 02:08:32 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:17689 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1KIHIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 02:08:31 -0500
Message-ID: <4EBA26D9.3050108@snapgear.com>
Date: Wed, 9 Nov 2011 17:08:09 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: manual merge of the m68knommu tree with the m68k
 tree
References: <20111109111519.7d8969103ab32e7e8193c018@canb.auug.org.au>
In-Reply-To: <20111109111519.7d8969103ab32e7e8193c018@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 11/09/2011 10:15 AM, Stephen Rothwell wrote:
> Today's linux-next merge of the m68knommu tree got a conflict in
> arch/m68k/Kconfig between commit d890d7399525 ("m68k/irq: Remove obsolete
> m68k irq framework") from the m68k tree and commit 4e8a9e70dfe8 ("m68k:
> selection of GENERIC_ATOMIC64 is not MMU specific") from the m68knommu
> tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks. Both this and the previous m68k merge conflict patch look good.

Geert: would you prefer I hold off on these 2 patches until after
you merge your IRQ changes?

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
