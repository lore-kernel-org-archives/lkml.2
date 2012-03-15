Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031773Ab2COQjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:39:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61890 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031645Ab2COQju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:39:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: linux-next: build failure after merge of the final tree (arm-soc tree related)
Date: Thu, 15 Mar 2012 16:39:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, Michael Walle <michael@walle.cc>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120315105901.7b10c9f4de9374a613436988@canb.auug.org.au> <20120315002020.GA16189@titan.lakedaemon.net>
In-Reply-To: <20120315002020.GA16189@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203151639.38223.arnd@arndb.de>
X-Provags-ID: V02:K0:ErPSngExKWxoaUa9wLSmZETMf7PP1EqiISIfAAtrCrv
 fWgLks1z+BqTKPQzQ2zynnxa7p5yyekhIGU0Ml3hroULHO5x/0
 ZcWz2AW9IrCjTJ982OHFoik55CxoWsCJhUt60Hixt/YCuoiIza
 IZP2RIYVA4jM/4DWaLNtfI2Kmi8VQ5+yiSDqC6r/gBW8KXTZy/
 DdLB0hkFppNUo2M7Hjssj7i+G2tgaCY41nPDX9B770YCw1WErT
 xWfRwQAan/fQNWl/HHoBuafFy/LUfHNfQ2pQh9pLkcbIRKYbed
 fkU4qvGDgwGRBu8+5Hv1w3pAULUAMuzNT97QYTCAbV0RlGutic
 gf7+c1mqOeMg/yEkgXvE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2012, Jason Cooper wrote:
> That's my mistake.  I did a pull request for the wrong branch.  Olof,
> could you please drop the offending branch and I'll submit a new pull
> request once I have a chance to test Arnd's irq patch?

I reverted this in the for-next branch for now. The two initial patches
from the kirkwood/board branch are still present.

	Arnd
