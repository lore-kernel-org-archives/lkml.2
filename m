Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0GRJBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 05:01:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59179 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab0GRJBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 05:01:07 -0400
Date: Sun, 18 Jul 2010 10:00:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM/nuc900: fix nuc900 touchscreen clk definition bug
Message-ID: <20100718090056.GC24707@n2100.arm.linux.org.uk>
References: <4C3FCBFF.50506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3FCBFF.50506@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 11:03:27AM +0800, Wan ZongShun wrote:
> This patch is to fix nuc900 touchscreen clk definition bug,the .dev_id's
> name should be 'nuc900-ts', it should be the same to pdev.name. or else,
> the touchscreen driver will be not working well due to clock engine disabled.

Ok.
