Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab2DLFZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:25:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51000 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab2DLFZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:25:31 -0400
Date: Thu, 12 Apr 2012 07:25:20 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Marc Kleine-Budde <mkl@blackshift.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] ARM: ixp4xx: fix compilation, add gpiolib support
Message-ID: <20120412052518.GA3260@netboy.at.omicron.at>
References: <1328729069-21308-1-git-send-email-mkl@blackshift.org>
 <1328729069-21308-2-git-send-email-mkl@blackshift.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328729069-21308-2-git-send-email-mkl@blackshift.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 08:24:28PM +0100, Marc Kleine-Budde wrote:
> From: Imre Kaloz <kaloz@openwrt.org>
> 
> The problem was introduced with commit:
> "eb9ae7f gpio: fix build error in include/asm-generic/gpio.h"
> 
> This patch adds gpiolib support for the IXP4xx platform, which fixes the
> compilation of several ixp4xx platforms, e.g.:

Sorry to nag, but is someone going to take this patch?

Thanks,
Richard
