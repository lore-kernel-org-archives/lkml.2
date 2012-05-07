Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2EGI5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:57:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2EGI5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:57:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the crypto tree with Linus' tree
Date: Mon, 7 May 2012 08:09:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Westin <andreas.westin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
References: <20120507121137.bdfc96ed31649040506d9c75@canb.auug.org.au>
In-Reply-To: <20120507121137.bdfc96ed31649040506d9c75@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205070809.21709.arnd@arndb.de>
X-Provags-ID: V02:K0:HTzrpwhq601efVcCUPGjCns+2xWOQA1ltciJEVhpSBm
 UiYeS/6Snx35m6zzhzLJRjlod680T8YnU0e0nw9fRuCQKxwqIO
 O5uq+Mk5Sa0LW5S1+daiEFEVjLLn0WKHLcNSTMmAEhh4p2atur
 gut67ZeLh/PDBGMWyWDBUg9LMKBBFZO4RxwCmtJxUVr+RxQFwP
 QW+PX7+g5R3VLdCTK1NzipWTyp8Ke/nwKxb/j0+pGwlD5n+TdD
 14vlUCzNbhM02hBht1BA5DQp8nydtrO5CM6rv6oy8PKFzPulR4
 PsCYMBQlk1QkBW7dmcCkiJznffei8UafqaYPdL9HLGQDeddVT6
 7gmOcjBkL9KgNpePnGPQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 May 2012, Stephen Rothwell wrote:
> + static void __init u8500_cryp1_hash1_init(void)
> + {
> +       db8500_add_cryp1(&u8500_cryp1_platform_data);
> +       db8500_add_hash1(&u8500_hash1_platform_data);
> + }

This is actually not correct any more because of the
other changes: each device addition should also pass the parent
pointer so the device is created in the right position.

Stephen, your fix is ok for linux-next and I expect everything
to still work, but we should not merge it into v3.5 this way.

Thanks for the fixup.

	Arnd

