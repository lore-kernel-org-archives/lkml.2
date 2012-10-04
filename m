Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab2JDHBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 03:01:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab2JDHBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 03:01:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the signal tree with the modules and arm-soc trees
Date: Thu, 4 Oct 2012 07:01:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
References: <20121004145241.fac039e78a15bb614cbd6da0@canb.auug.org.au>
In-Reply-To: <20121004145241.fac039e78a15bb614cbd6da0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210040701.10636.arnd@arndb.de>
X-Provags-ID: V02:K0:4rKS7TzCkBVQEsSnij7+5MVgsl9ARanmqEzp5pRnCVU
 Lu2OzrXenyty7FEIdK/uF/PJ1/uQ0lYX+yj6aabeFpI1brh3z+
 VqH96kooSA1/GEIXjmpfUJavNtMoRFYH3dQiE2JWSVomXt7eKM
 OCiXqCc2hZjSlTTum78EhenUR/JSBICdsajx2KA/XFIvR8mRPn
 FwVWTuCGOOd1W9znvRPw2KSgsTh+alEi3YVfAzFSx0zB1KeOdt
 S4a/5b8rtrjq5yU1pQItr9w0T8ZF0akKvgEGLFtT9rwKqcPb/B
 zeNmhmwXGh90tVlOD1xUzaFoASZ2v+jWsaTKAVWmQtnbvNnonv
 JgLDZohCbCG/BjQ5Kc2s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2012, Stephen Rothwell wrote:
> Hi Al,
> 
> Today's linux-next merge of the signal tree got conflicts in
> arch/avr32/include/asm/Kbuild, arch/cris/include/asm/Kbuild,
> arch/frv/include/asm/Kbuild, arch/h8300/include/asm/Kbuild,
> arch/ia64/include/asm/Kbuild, arch/m32r/include/asm/Kbuild,
> arch/microblaze/include/asm/Kbuild, arch/mn10300/include/asm/Kbuild and
> arch/xtensa/include/asm/Kbuild between commit e7a570ff7dff ("asm-generic:
> Add default clkdev.h") from the arm-soc tree, commit 786d35d45cc4 ("Make
> most arch asm/module.h files use asm-generic/module.h") from the modules
> tree and commit ddd03a1f7591 ("get rid of generic instances of
> asm/exec.h") from the signal tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks for the three fixups. I was aware the conflicts would happen, but
your solutions are all correct. I had promised ot Mark a long time ago
to merge his patch and never actually done it.

My plan right now is to send the pull request after the other changes
have gone in and it's been in linux-next without new complaints for
a few days. The patch itself is very simple and should be harmless.

	Arnd
