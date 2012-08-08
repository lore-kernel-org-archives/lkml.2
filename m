Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab2HHPhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:37:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58075 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab2HHPhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:37:11 -0400
Date: Wed, 8 Aug 2012 16:36:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] ARM: sa1100: include asm/io.h in hackkit leds code
Message-ID: <20120808153655.GN18957@n2100.arm.linux.org.uk>
References: <1344430493-5304-1-git-send-email-arnd@arndb.de> <1344430493-5304-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344430493-5304-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 02:54:50PM +0200, Arnd Bergmann wrote:
> The sa1100 definition of the io_p2v macro has changed in v3.6, and this one
> file stopped working because of that.
> 
> Without this patch, building hackkit_defconfig results in:
> 
> arch/arm/mach-sa1100/leds-hackkit.c: In function 'hackkit_leds_event':
> arch/arm/mach-sa1100/leds-hackkit.c:39:4: error: implicit declaration of function 'IOMEM' [-Werror=implicit-function-declaration]

NAK.  Should be linux/io.h
