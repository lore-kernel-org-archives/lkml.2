Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706Ab1KJIlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:41:13 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45890 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab1KJIlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:41:12 -0500
MIME-Version: 1.0
In-Reply-To: <1320890178.13074.1.camel@phoenix>
References: <1320890178.13074.1.camel@phoenix>
Date: Thu, 10 Nov 2011 09:41:10 +0100
Message-ID: <CACRpkda1590n+2P5dt9RmmGwPt_WP-u=M3+pDMeO_+kQ_qNBjg@mail.gmail.com>
Subject: Re: [PATCH] mfd: add #ifdef CONFIG_DEBUG_FS guard for ab8500_debug_resources
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 2:56 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Fix below build warning if CONFIG_DEBUG_FS is disabled.
>
>  CC      drivers/mfd/ab8500-core.o
> drivers/mfd/ab8500-core.c:623: warning: 'ab8500_debug_resources' defined but not used
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Axel!
Linus Walleij
