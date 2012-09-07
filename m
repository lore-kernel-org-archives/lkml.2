Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab2IGFsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 01:48:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50192 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2IGFsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 01:48:50 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <5049346B.5020205@gmail.com>
References: <1346675368.15950.0.camel@phoenix> <5049346B.5020205@gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 7 Sep 2012 13:48:30 +0800
Message-ID: <CAF+7xWko4wokuU-OiMYq3a2RJyaSb=qXM+LOpJCKHYpEB1Xi2Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: ep93xx: Fix build error due to 'SZ_32M' undeclared
To: Ryan Mallon <rmallon@gmail.com>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Axel,
>
> The patch looks fine. I notice that the other ep93xx boards are also
> using the SZ_ defines, but are indirectly including linux/sizes.h via
> asm/memory.h, which in turn is indirectly included via asm/io.h. That
Seems this is also true for other platforms ( e.g. mach-pxa, mach-ux500, etc)

> seems a bit flaky, so I wonder if we should just explicitly include
> <linux/sizes.h> in all the board files which use the SZ_ macros as per
> the patch below. Thoughts?
I'm 50/50 on this.
But if we do these changes, this patch is more than a build fix.

Regards,
Axel
