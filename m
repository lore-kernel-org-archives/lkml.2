Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948Ab2F2Ess (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 00:48:48 -0400
Received: from dnvwsmailout1.mcafee.com ([161.69.31.173]:52200 "EHLO
	DNVWSMAILOUT1.mcafee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2F2Esr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 00:48:47 -0400
Message-ID: <4FED33AB.5020101@snapgear.com>
Date: Fri, 29 Jun 2012 14:48:43 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Steven King <sfking@fdwdc.com>
Subject: Re: linux-next: manual merge of the m68knommu tree with Linus' tree
References: <20120629113310.e578f61aa71e9350a3596833@canb.auug.org.au>
In-Reply-To: <20120629113310.e578f61aa71e9350a3596833@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 29/06/12 11:33, Stephen Rothwell wrote:
> Today's linux-next merge of the m68knommu tree got a conflict in
> arch/m68k/platform/coldfire/clk.c between commit 19a1d332cc8c
> ("m68knommu: define a local devm_clk_get() function") from Linus' tree
> and commit a0412a2ddaa3 ("m68knommu: Add support for the Coldfire
> m5441x") from the m68knommu tree.

Ah, yes, that would be right.


> I fixed it up (I think - see below) and can carry the fix as necessary.

I think though that the change made by commit 19a1d332cc8c ("m68knommu:
define a local devm_clk_get() function") needs also to be carried through
to the other "#else" branch with an appropriately coded devm_clk_get() as
well. I suspect it needs more than the trivial code added by
commit 19a1d332cc8c.

I'll check this out further an update my for-next as required.

Thanks
Greg



-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com


