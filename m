Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2FLRgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:36:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59204 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2FLRgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:36:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] sched/numa: fix compat declarations for sys_numa_{t,m}bind()
Date: Tue, 12 Jun 2012 17:36:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201206121724.q5CHOaeU002148@farm-0023.internal.tilera.com>
In-Reply-To: <201206121724.q5CHOaeU002148@farm-0023.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206121736.36586.arnd@arndb.de>
X-Provags-ID: V02:K0:vwBJ0eV/YnWP91FOZTzmlB6X4GynrC6cMd7tqgS/eBX
 WA+SQueqHMbnjVkYAecnBzlyXd61lpkz7CBBGwuNu1hYaePJ+w
 obFn1BSZXo1x9b4LIzS9yFD/xzU1tYYPfboAslZxkwN/zrBhlr
 y4Feo7ug+f3i29QwHO+6+A84Fbj506K9VvzNfqXbEm+owjZpKE
 aKDm3PKazvXDWe3n680ZBFd9s6mRG49F452Xh70FHDzFu3Lcih
 3Sk9VXFVjBkcNUl1L3LJtvQzvPjCVVfp8iOFvT1vO7pbQ3rvdb
 lGd5f5FoOyeikZRK9jIpxUdmnI83yYJiEs/FdC0y7v3KD3obqI
 B7H7RKgecmheA0wTYDk8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2012, Chris Metcalf wrote:
> The asm-generic code needs actual declarations of the routines,
> and the syscall entries need to reference the correct names.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> The tilegx architecture is currently broken in linux-next because
> of this issue.

Acked-by: Arnd Bergmann <arnd@arndb.de>

Please apply to the branch that contains the syscall implementation.
