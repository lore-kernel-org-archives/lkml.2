Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab2GLAcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:32:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55312 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab2GLAcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:32:20 -0400
Date: Wed, 11 Jul 2012 17:32:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: devel@driverdev.osuosl.org, b-cousson@ti.com, j-keerthy@ti.com,
        linux-kernel@vger.kernel.org, kbaidarov@dev.rtsoft.ru,
        grant.likely@secretlab.ca
Subject: Re: [PATCHv3 1/4] staging: OMAP4+: thermal: introduce bandgap
 temperature sensor
Message-ID: <20120712003216.GA9827@kroah.com>
References: <1342039269-13968-1-git-send-email-eduardo.valentin@ti.com>
 <1342039269-13968-2-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1342039269-13968-2-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 11:41:06PM +0300, Eduardo Valentin wrote:
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
> Signed-off-by: J Keerthy <j-keerthy@ti.com>

This patch gives me the following build error:

rivers/staging/omap-thermal/omap-bandgap.c: In function ‘omap_bandgap_build’:
drivers/staging/omap-thermal/omap-bandgap.c:805:2: error: implicit declaration of function ‘of_match_device’ [-Werror=implicit-function-declaration]
drivers/staging/omap-thermal/omap-bandgap.c:805:8: warning: assignment makes pointer from integer without a cast [enabled by default]

So of course I can't accept it :(

How hard is it to test that the patches build before sending them to me?

ugh,

greg k-h
