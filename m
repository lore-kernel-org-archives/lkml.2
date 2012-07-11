Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2GKMwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:52:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45434 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2GKMwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:52:10 -0400
Date: Wed, 11 Jul 2012 05:52:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Valentin, Eduardo" <eduardo.valentin@ti.com>
Cc: devel@driverdev.osuosl.org, b-cousson@ti.com, j-keerthy@ti.com,
        linux-kernel@vger.kernel.org, kbaidarov@dev.rtsoft.ru,
        grant.likely@secretlab.ca
Subject: Re: [PATCHv2 1/4] staging: OMAP4+: thermal: introduce bandgap
 temperature sensor
Message-ID: <20120711125206.GB6615@kroah.com>
References: <1341647872-15267-1-git-send-email-eduardo.valentin@ti.com>
 <1341647872-15267-2-git-send-email-eduardo.valentin@ti.com>
 <20120709193130.GA12982@kroah.com>
 <CAGF5oy_QVyYKFcS_62dffkRRZhBZrG4RTpYG9HKT8zMoLue1Xw@mail.gmail.com>
 <CAGF5oy-Ey7mB+_gjDWxm7H5muvpGrksTmjBsrn-Pva6N=JHNoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGF5oy-Ey7mB+_gjDWxm7H5muvpGrksTmjBsrn-Pva6N=JHNoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 01:07:17PM +0300, Valentin, Eduardo wrote:
> Hello Greg,
> 
> On Mon, Jul 9, 2012 at 11:33 PM, Valentin, Eduardo
> <eduardo.valentin@ti.com> wrote:
> > Hello Greg,
> >
> > On Mon, Jul 9, 2012 at 10:31 PM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >> On Sat, Jul 07, 2012 at 10:57:49AM +0300, Eduardo Valentin wrote:
> >>> In the System Control Module, OMAP supplies a voltage reference
> >>> and a temperature sensor feature that are gathered in the band
> >>> gap voltage and temperature sensor (VBGAPTS) module. The band
> >>> gap provides current and voltage reference for its internal
> >>> circuits and other analog IP blocks. The analog-to-digital
> >>> converter (ADC) produces an output value that is proportional
> >>> to the silicon temperature.
> >>>
> >>> This patch provides a platform driver which expose this feature.
> >>> It is moduled as a MFD child of the System Control Module core
> >>> MFD driver.
> >>>
> >>> This driver provides only APIs to access the device properties,
> >>> like temperature, thresholds and update rate.
> >>>
> >>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> >>> Signed-off-by: Keerthy <j-keerthy@ti.com>
> >>
> >> As much as I enjoy interesting names, odds are, "Keerthy" is not the
> >> real name of this person, right?  In fact, based on the copyright
> >> comments in the code, I can almost guarantee it...
> >>
> >> I need a full-name please, no aliases or fake names allowed in kernel
> >> signed-off-by lines.
> >>
> >> Please resend these with that fixed up.
> >
> > Actually, his name is in fact Keerthy J.  I can resend with the
> > additional "J" the way it is in the copyrights.
> 
> While looking into his commits, I believe the SOB in this patch is one
> of the ways he uses to sign:
> commit f99c1d4f94f91fd3a20bd2eaa3be9c5e7d2668eb
> Author: Keerthy <j-keerthy@ti.com>
> Date:   Tue Mar 1 19:12:26 2011 +0530
> 
>     mfd: Add twl4030 madc driver
> 
>     Introducing a driver for MADC on TWL4030 powerIC. MADC stands for monitoring
>     ADC. This driver monitors the real time conversion of analog signals like
>     battery temperature, battery cuurent etc.
> 
>     Signed-off-by: Keerthy <j-keerthy@ti.com>
>     Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> So, I'd prefer to keep the way it is.

But it doesn't match the copyright notice, which I am guessing TI got
"right" from a legal perspective, and as such, we need to also.

thanks,

greg k-h
