Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1BERdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:33:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57926 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1BERdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:33:05 -0500
Date: Sat, 5 Feb 2011 17:32:59 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dell-wmi: Received unknown WMI event (0x11)
Message-ID: <20110205173259.GA28134@srcf.ucam.org>
References: <20110205171807.GA3738@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110205171807.GA3738@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 07:18:07PM +0200, Felipe Balbi wrote:

> [  393.020537] dell-wmi: Received unknown WMI event (0x11)
> [  832.336855] dell-wmi: Received unknown WMI event (0x11)
> [  832.409353] dell-wmi: Received unknown WMI event (0x11)
> [  833.621140] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [  834.367611] dell-wmi: Received unknown WMI event (0x11)
> [ 1001.665940] dell-wmi: Received unknown WMI event (0x11)
> [ 1002.846845] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 1003.591459] dell-wmi: Received unknown WMI event (0x11)
> [ 1063.690326] dell-wmi: Received unknown WMI event (0x11)
> [ 1064.942777] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 1644.787491] dell-wmi: Received unknown WMI event (0x11)
> [ 1644.849026] dell-wmi: Received unknown WMI event (0x11)
> [ 1645.971790] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 1646.719084] dell-wmi: Received unknown WMI event (0x11)
> [ 2317.273481] dell-wmi: Received unknown WMI event (0x11)
> [ 2318.540645] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 2319.285487] dell-wmi: Received unknown WMI event (0x11)
> [ 2379.364740] dell-wmi: Received unknown WMI event (0x11)
> [ 2877.001258] dell-wmi: Received unknown WMI event (0x11)
> [ 2878.211188] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 2878.957282] dell-wmi: Received unknown WMI event (0x11)
> [ 2903.422959] dell-wmi: Received unknown WMI event (0x11)
> [ 2904.609272] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 2905.352451] dell-wmi: Received unknown WMI event (0x11)
> [ 2965.454915] dell-wmi: Received unknown WMI event (0x11)
> [ 2966.701330] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 3981.339257] dell-wmi: Received unknown WMI event (0x11)
> [ 3982.510612] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 3983.254770] dell-wmi: Received unknown WMI event (0x11)
> [ 4045.466929] dell-wmi: Received unknown WMI event (0x11)
> [ 4046.631137] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 4047.391614] dell-wmi: Received unknown WMI event (0x11)
> [ 4107.480071] dell-wmi: Received unknown WMI event (0x11)
> [ 4108.631339] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 4731.506881] dell-wmi: Received unknown WMI event (0x11)
> [ 4732.646424] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> [ 4733.391238] dell-wmi: Received unknown WMI event (0x11)
> [ 6025.385179] cdrom: This disc doesn't have any tracks I recognize!

Nothing's changed in dell-wmi in that timeframe, so I suspect it's some 
other issue that's triggering here and the hardware is responding by 
sending events? Alternatively, these messages are pretty spread out. Do 
they directly correspond to you trying to burn something?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
