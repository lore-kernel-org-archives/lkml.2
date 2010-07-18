Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0GRJAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 05:00:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59176 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab0GRJAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 05:00:19 -0400
Date: Sun, 18 Jul 2010 10:00:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM/nuc900: re-organize the nuc900 lcd arch platform
	data setting
Message-ID: <20100718090009.GB24707@n2100.arm.linux.org.uk>
References: <4C400377.3020408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C400377.3020408@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 03:00:07PM +0800, Wan ZongShun wrote:
> The patch re-organizes the nuc900 lcd arch platform data,
> remove the lcd platform data setting from nuc950.c to dev.c
> 
> It can maximize the share codes between nuc900 series MCUs.

Ok.
