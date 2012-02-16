Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2BPIu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 03:50:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32877 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2BPIu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 03:50:27 -0500
Date: Thu, 16 Feb 2012 08:50:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: nicolas.pitre@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: boot/compressed/decompress.c cleanup
Message-ID: <20120216085010.GI13673@n2100.arm.linux.org.uk>
References: <1329370449-12033-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329370449-12033-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 06:34:09AM +0100, Michael Opdenacker wrote:
> - Remove the ARCH_HAS_DECOMP_WDOG define
>   because it is only used in lib/deflate.c, which
>   only the alpha architecture uses. No other architecture
>   uses this define

No.  Your grepping is broken.
