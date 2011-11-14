Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab1KNA1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:27:33 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:40495 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab1KNA1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:27:31 -0500
Message-ID: <4EC060D0.5000808@snapgear.com>
Date: Mon, 14 Nov 2011 10:29:04 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kars de Jong <jongk@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: manual merge of the m68knommu tree with the m68k
 tree
References: <20111114110305.5b04e0b5509cd0489c7d9440@canb.auug.org.au>
In-Reply-To: <20111114110305.5b04e0b5509cd0489c7d9440@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 14/11/11 10:03, Stephen Rothwell wrote:
> Today's linux-next merge of the m68knommu tree got a conflict in
> arch/m68k/Kconfig.debug between commit 049755db2c3f ("m68k/mvme16x: Add
> support for EARLY_PRINTK") from the m68k tree and commit d0106cf0aa29
> ("m68k: support configure time command line for MMU m68k") from the
> m68knommu tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks for the heads up. Geert's irq changes have been pushed in now,
so I will rebase my patches and fix up the few bits of breakage you
have seen.

Thanks
Greg


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
