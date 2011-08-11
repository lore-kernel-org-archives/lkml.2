Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1HKVNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:13:44 -0400
Received: from void.printf.net ([89.145.121.20]:33877 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab1HKVNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:13:42 -0400
From: Chris Ball <cjb@laptop.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Zhu <richard.zhu@linaro.org>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: linux-next: manual merge of the mmc tree with Linus' tree
References: <20110811135555.f4b26adb8a73c1a22f75abc5@canb.auug.org.au>
Date: Thu, 11 Aug 2011 17:13:19 -0400
In-Reply-To: <20110811135555.f4b26adb8a73c1a22f75abc5@canb.auug.org.au>
	(Stephen Rothwell's message of "Thu, 11 Aug 2011 13:55:55 +1000")
Message-ID: <m2obzvps7k.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Aug 10 2011, Stephen Rothwell wrote:
> Today's linux-next merge of the mmc tree got a conflict in
> drivers/mmc/host/sdhci-esdhc-imx.c between commit 913413c307c9 ("mmc:
> sdhci-esdhc-imx: extend card_detect and write_protect support for mx5")
> from Linus' tree and commit 612e807e4852 ("mmc: sdhci-esdhc-imx: Enable
> ADMA2") from the mmc tree.
>
> I fixed it up (I think - see below) anc can carry the fix as necessary.

Thanks for the conflict fixup.  I've merged 3.1-rc1 into mmc-next
and compile-tested for mx35, so the mmc tree should be clean now.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
