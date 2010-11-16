Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093Ab0KPJWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 04:22:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64286 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934055Ab0KPJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:22:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the bkl-config tree
Date: Tue, 16 Nov 2010 10:21:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20101116130853.a3c66c4b.sfr@canb.auug.org.au>
In-Reply-To: <20101116130853.a3c66c4b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011161021.57734.arnd@arndb.de>
X-Provags-ID: V02:K0:u30yGjP5BIEdD1lf6nBVacfhWhp6mvA1m2c4Y48sSm4
 ZlpwfZlZ3pvu0OLlkpt0R1kLk2rg3vFLoM6BTf9F+/wrev6aDZ
 f5KbSlualb9jYfjgrNT9LUUF2jqZOC/pAiI0czx2hTpM70XERE
 RTUmTn207z9QZ4nhlJWzKlkf05ZH6oB2D9+hCD6ZkglWPULHyy
 BwSMVQHWGhHHMqGsVvQ7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 November 2010 03:08:53 Stephen Rothwell wrote:
> After merging the bkl-config tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> kernel/sched.c: In function 'schedule':
> kernel/sched.c:3896: error: implicit declaration of function 'release_kernel_lock'
> kernel/sched.c:3960: error: implicit declaration of function 'reacquire_kernel_lock'
> 
> Caused by commit 8bbc75c71b8a821edd8abb43452c78fbfd4789dc ("BKL: remove
> extraneous #include <smp_lock.h>").  Not well build tested :-(

Yes, and bad timing. I noticed this in a build test after uploading it,
and uploaded the fixed tree half an hour later, just after you pulleed it :(
Sorry about this, next time I'll do it in the right order.

	Arnd
