Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1DTP0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:26:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40830 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752787Ab1DTP0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:26:53 -0400
Date: Wed, 20 Apr 2011 16:26:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv3 3/4] TPS65910: IRQ: Add interrupt controller
Message-ID: <20110420152651.GB9869@opensource.wolfsonmicro.com>
References: <5728ED73-0475-4240-BEA5-00EB9BA20275@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5728ED73-0475-4240-BEA5-00EB9BA20275@slimlogic.co.uk>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 08:27:32PM -0500, Jorge Eduardo Candelaria wrote:
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
