Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab0IOLAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:00:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60259 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752681Ab0IOLAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:00:04 -0400
Date: Wed, 15 Sep 2010 12:00:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saeed Bishara <saeed@marvell.com>
Cc: Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: Add architecture dependency for Marvell SoC
 controller
Message-ID: <20100915110001.GA4254@rakim.wolfsonmicro.main>
References: <1284366279-17140-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100914190549.GA21918@void.printf.net>
 <20100915094006.GA21620@sirena.org.uk>
 <FCBE654890C0334289D0AD3AF4EF009FD18EE74AA8@IL-MB01.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FCBE654890C0334289D0AD3AF4EF009FD18EE74AA8@IL-MB01.marvell.com>
X-Cookie: No guts, no glory.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 12:55:33PM +0300, Saeed Bishara wrote:

> I think the PLAT_PXA it too general, maybe you better specify the
> exact ARCH (ARCH_MMP).

Which CPUs does the driver actually support?  The Kconfig and commit log
just say "Marvell" so I went for the conservative option and included
all Marvell CPUs I was aware of.
