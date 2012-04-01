Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab2DANCe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 09:02:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39359 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2DANCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 09:02:32 -0400
Date: Sun, 1 Apr 2012 14:02:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Turquette <mturquette@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: Fix comment for end of CONFIG_COMMON_CLK
	section
Message-ID: <20120401130216.GA24211@n2100.arm.linux.org.uk>
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 12:32:39PM +0100, Mark Brown wrote:
> There is no else block so the #endif is for the end of the section for
> CONFIG_COMMON_CLK.

Get rid of the comment entirely.  For just a single level of ifdef it
makes no sense.
