Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0CWG1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 02:27:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720Ab0CWG1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 02:27:39 -0400
Date: Mon, 22 Mar 2010 23:26:42 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Maurus Cuelenaere <mcuelenaere@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH] S3C RTC driver: add support for S3C64xx
Message-Id: <20100322232642.34a1474d.akpm@linux-foundation.org>
In-Reply-To: <b2e8f9f71003220426j9bdb088w343bcebe642247f6@mail.gmail.com>
References: <b2e8f9f71003220426j9bdb088w343bcebe642247f6@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010 12:26:48 +0100 Maurus Cuelenaere <mcuelenaere@gmail.com> wrote:

> Add support for the S3C64xx SoC to the generic S3C RTC driver.
> 
> Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
> Acked-By: Ben Dooks <ben-linux@fluff.org>
> ---
> 
> This was sent to rtc-linux before (12/01/2010), but no response was
> received yet.
> See http://groups.google.com/group/rtc-linux/browse_thread/thread/2a2dfc23a8042f3d/2812dcbafd9a0a85
> for the full thread.
> 
> At 08/03/2010 I posted this to LKML, with no result.
> On recommendation of Frans Pop, I resend this to LKML with Andrew Morton in CC.
> 
> The platform part of this patch has been included in 2.6.34-rc2.
> 
>  arch/arm/plat-s3c/include/plat/regs-rtc.h |    4 +

That was sneaky.  I assume that
arch/arm/plat-s3c/include/plat/regs-rtc.h is a symlink to
arch/arm/plat-samsung/include/plat/regs-rtc.h on your machine - it
doesn't exist on mine.  I fixed the patch so it patches the correct
path.

>  drivers/rtc/Kconfig                       |    2 +-
>  drivers/rtc/rtc-s3c.c                     |  107 +++++++++++++++++++++++------
>  3 files changed, 92 insertions(+), 21 deletions(-)

The patch had a bit of wordwrapping.  Please watch out for these things
next time.

