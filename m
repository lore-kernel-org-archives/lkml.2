Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761720Ab2KAO5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:57:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab2KAO5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:57:01 -0400
Subject: Re: [PATCH 4/5] c6x: Use generic asm/mmu.h
From: Mark Salter <msalter@redhat.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Aurelien Jacquiot <a-jacquiot@ti.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org
Date: Thu, 01 Nov 2012 10:56:35 -0400
In-Reply-To: <1351765467-29244-4-git-send-email-lars@metafoo.de>
References: <1351765467-29244-1-git-send-email-lars@metafoo.de>
	 <1351765467-29244-4-git-send-email-lars@metafoo.de>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1351781799.22206.94.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-01 at 11:24 +0100, Lars-Peter Clausen wrote:
> c6x's asm/mmu.h is basically identical to asm-generic/mmu.h, so use it
> instead
> of the custom version.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> ---
> Note, due to lack of toolchain, etc this patch is completely untested.
> ---
>  arch/c6x/include/asm/Kbuild |    1 +
>  arch/c6x/include/asm/mmu.h  |   22 ----------------------
>  2 files changed, 1 insertions(+), 22 deletions(-)
>  delete mode 100644 arch/c6x/include/asm/mmu.h

Acked-by: Mark Salter <msalter@redhat.com>
Tested-by: Mark Salter <msalter@redhat.com>


