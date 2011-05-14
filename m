Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab1ENQO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 12:14:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42621 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752961Ab1ENQO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 12:14:29 -0400
Date: Sat, 14 May 2011 09:14:28 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Margarita Olaya <magi@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        sameo@linux.intel.com
Subject: Re: [PATCHv2 2/4] tps65912: irq: add interrupt controller
Message-ID: <20110514161427.GF2791@opensource.wolfsonmicro.com>
References: <BANLkTimZkNa4_N8=7=H8JThZgjtocN0gFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimZkNa4_N8=7=H8JThZgjtocN0gFg@mail.gmail.com>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 01:43:03PM -0500, Margarita Olaya wrote:
> This module controls the interrupt handling for the tps65912.
> The interrupt sources can be the following:
> 
> - GPIO
> - PWRON signal
> - PWRHOLD signal
> - Temperature detection
> 
> Signed-off-by: Margarita Olaya Cabrera <magi@slimlogic.co.uk>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

modulo the comment fix.
