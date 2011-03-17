Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1CQKV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:21:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46388 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1CQKV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:21:56 -0400
Date: Thu, 17 Mar 2011 10:21:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de, u.kleine-koenig@pengutronix.de,
        arnaud.patard@rtp-net.org, ra5478@freescale.com,
        xiao-lizhang@freescale.com, festevam@gmail.com
Subject: Re: [PATCHv3 2/3] ARM: mx51: Implement code to allow mx51 to enter
	WFI
Message-ID: <20110317102147.GG29758@n2100.arm.linux.org.uk>
References: <1300305787-7970-1-git-send-email-Dinh.Nguyen@freescale.com> <1300305787-7970-2-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300305787-7970-2-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 03:03:06PM -0500, Dinh.Nguyen@freescale.com wrote:
> +#include <linux/platform_device.h>
> +#include <asm/io.h>

linux/io.h please.
