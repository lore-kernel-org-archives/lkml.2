Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab1AKVPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:15:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55678 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab1AKVPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:15:11 -0500
Date: Tue, 11 Jan 2011 21:15:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 16/16] w1: mxc_w1: don't treat NULL clk as an error
Message-ID: <20110111211502.GP11039@n2100.arm.linux.org.uk>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com> <1294749833-32019-17-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294749833-32019-17-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 12:43:53PM +0000, Jamie Iles wrote:
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.

Another good catch.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks for doing this.
