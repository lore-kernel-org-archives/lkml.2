Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab1D0Kpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:45:51 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:56238 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987Ab1D0Kps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:45:48 -0400
Date: Wed, 27 Apr 2011 13:45:44 +0300
From: Felipe Balbi <balbi@ti.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 4/4] USB: TWL6025 allow different regulator name
Message-ID: <20110427104542.GZ13227@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
 <1303897191-14792-5-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303897191-14792-5-git-send-email-gg@slimlogic.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 27, 2011 at 10:39:51AM +0100, Graeme Gregory wrote:
> The twl6025 uses a different regulator for USB than the 6030 so select
> the correct regulator name depending on the subclass of device.
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>

I don't see the point of this patch. It's just a string. Use the same
name and add a comment saying that on datasheet/TRM/documentation the
name LDO is actually referred to as LDOUSB. It's the same functionality
anyway.

-- 
balbi
