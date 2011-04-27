Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab1D0JOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:14:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60977 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754831Ab1D0JOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:14:07 -0400
Date: Wed, 27 Apr 2011 10:14:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv4 3/4] TPS65910: IRQ: Add interrupt controller
Message-ID: <20110427091415.GC16666@opensource.wolfsonmicro.com>
References: <F26256FF-CD37-496F-9DB0-35E9D5407DBB@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F26256FF-CD37-496F-9DB0-35E9D5407DBB@slimlogic.co.uk>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 09:35:49AM -0500, Jorge Eduardo Candelaria wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> This module controls the interrupt handling for the tps chip. The
> interrupt sources are the following:
> 
> - GPIO falling/rising edge detection
> - Battery voltage below/above threshold
> - PWRON signal
> - PWRHOLD signal
> - Temperature detection
> - RTC alarm and periodic event
> 
> Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
