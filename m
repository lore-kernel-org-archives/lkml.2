Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1CPJDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 05:03:53 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:56722 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418Ab1CPJDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 05:03:47 -0400
Date: Wed, 16 Mar 2011 11:03:28 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: balbi@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: musb as module broken in 2.6.38
Message-ID: <20110316090327.GA2325@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4D8018A9.6000800@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8018A9.6000800@ahsoftware.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 16, 2011 at 02:55:53AM +0100, Alexander Holler wrote:
> in commit dc09886bfa781e2b442301116c18199519e36f0f the name of the
> platform-driver was splitted and musb-omap2430 is used for several
> boards (arch/arm/mach-omap2/usb-musb.c).
> 
> But musb_hdrc still uses musb-hdrc as name when
> platform_driver_probe() is called. The result is that loading the
> driver (when build as a module) doesn't work anymore (it doesn't find
> the platform-device).
> 
> Do I miss something or was something forgotten when the glue-layers
> for musb got introduced?
> 
> (The driver still works when linked into the kernel, but is
> disfunctional when build as a module.)

Send me the output you get on console and a snippet of the .config with
the MUSB section.

-- 
balbi
