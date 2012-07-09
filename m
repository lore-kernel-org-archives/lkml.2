Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2GITbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:31:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36241 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2GITbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:31:35 -0400
Date: Mon, 9 Jul 2012 12:31:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: devel@driverdev.osuosl.org, b-cousson@ti.com, j-keerthy@ti.com,
        linux-kernel@vger.kernel.org, kbaidarov@dev.rtsoft.ru,
        grant.likely@secretlab.ca
Subject: Re: [PATCHv2 1/4] staging: OMAP4+: thermal: introduce bandgap
 temperature sensor
Message-ID: <20120709193130.GA12982@kroah.com>
References: <1341647872-15267-1-git-send-email-eduardo.valentin@ti.com>
 <1341647872-15267-2-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341647872-15267-2-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 10:57:49AM +0300, Eduardo Valentin wrote:
> In the System Control Module, OMAP supplies a voltage reference
> and a temperature sensor feature that are gathered in the band
> gap voltage and temperature sensor (VBGAPTS) module. The band
> gap provides current and voltage reference for its internal
> circuits and other analog IP blocks. The analog-to-digital
> converter (ADC) produces an output value that is proportional
> to the silicon temperature.
> 
> This patch provides a platform driver which expose this feature.
> It is moduled as a MFD child of the System Control Module core
> MFD driver.
> 
> This driver provides only APIs to access the device properties,
> like temperature, thresholds and update rate.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> Signed-off-by: Keerthy <j-keerthy@ti.com>

As much as I enjoy interesting names, odds are, "Keerthy" is not the
real name of this person, right?  In fact, based on the copyright
comments in the code, I can almost guarantee it...

I need a full-name please, no aliases or fake names allowed in kernel
signed-off-by lines.

Please resend these with that fixed up.

greg k-h
