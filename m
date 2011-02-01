Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab1BALwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 06:52:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40947 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1BALwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 06:52:02 -0500
Date: Tue, 1 Feb 2011 11:51:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, liu.y.victor@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        B02280@freescale.com
Subject: Re: [PATCH 3/9] Add a mfd IPUv3 driver
Message-ID: <20110201115125.GE31216@n2100.arm.linux.org.uk>
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de> <1292842127-21406-4-git-send-email-s.hauer@pengutronix.de> <20110201105127.GA10128@sortiz-mobl> <20110201105909.GS9041@pengutronix.de> <20110201114453.GC10128@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201114453.GC10128@sortiz-mobl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 12:44:54PM +0100, Samuel Ortiz wrote:
> Ok, so would moving it do drivers/video/ make sense ?

Isn't that for framebuffer drivers?
