Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab1DNKdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:33:03 -0400
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:38627 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932725Ab1DNKdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:33:00 -0400
Date: Thu, 14 Apr 2011 13:32:55 +0300
From: Felipe Balbi <balbi@ti.com>
To: Juergen Kilb <J.Kilb@phytec.de>
Cc: linux-arm-kernel@lists.infradead.org, dbrownell@users.sourceforge.net,
        balbi@ti.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH] Fixed gpio polarity of gpio USB-phy reset.
Message-ID: <20110414103254.GC14319@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1302766303-1157-1-git-send-email-J.Kilb@phytec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302766303-1157-1-git-send-email-J.Kilb@phytec.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 09:31:43AM +0200, Juergen Kilb wrote:
> With commit 19403165 a main part of ehci-omap.c moved to
> drivers/mfd/omap-usb-host.c created by commit 17cdd29d.
> Due to this reorganisation the polarity used to reset the
> external USB phy changed and USB host doesn't recognize
> any devices.
> 
> Signed-off-by: Juergen Kilb <J.Kilb@phytec.de>

Judging by how ehci-omap.c was before moving the code:

Acked-by: Felipe Balbi <balbi@ti.com>

-- 
balbi
