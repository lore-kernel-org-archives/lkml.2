Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2IOUOn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 16:14:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50417 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2IOUOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 16:14:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 17/24] ARM: OMAP: use __iomem pointers for MMIO
Date: Sat, 15 Sep 2012 20:14:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <1347658492-11608-18-git-send-email-arnd@arndb.de> <20120915181057.GH4521@atomide.com>
In-Reply-To: <20120915181057.GH4521@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209152014.37989.arnd@arndb.de>
X-Provags-ID: V02:K0:3TO6y9v6xK1Z5QkOydXUhGx98XQqR79D6an375OYQNy
 yb/EUUEKvHBtqyiY+uoRpXuFgOK9txoF3Wsyh+z3NzYlVa00Dr
 HAtEUc/Xn4fxkFHRAFJJXyyy8NCnghQOMFEa7sMbxVG4rJk9lT
 7CmJ9wjI3xDSO67PidyeJdDY1TA+o3rhIoKo8FNa5BQjlcEbi8
 UszDwCVGbDLXJUZP0TU6VjOrLw4sNqg8l8odMXf2w9EKiGqsyH
 keZsobGfirCWG5FiFLJlVtLQMwkKLL0IKjIgeynrbibU/U0mrM
 T2laiyNA7PKNKfjnjsmxfrXlv5Z1yoohzgaifl/tE9Idku0kk4
 EYp30hFMayIzVEQmiIJE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 September 2012, Tony Lindgren wrote:
> With my patches, this is now all omap1 specific and
> moved to arch/arm/mach-omap1/include/mach/hardware.h.
> It's probably easiest to just update this patch on
> top of the hardware.h changes I've done.

Yes, sounds good. Do you want to send a patch for that
and let me drop this one then?

	Arnd
