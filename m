Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1BERla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:41:30 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:48551 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538Ab1BERl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:41:29 -0500
Date: Sat, 5 Feb 2011 19:41:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dell-wmi: Received unknown WMI event (0x11)
Message-ID: <20110205174124.GB2619@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110205171807.GA3738@legolas.emea.dhcp.ti.com>
 <20110205173259.GA28134@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110205173259.GA28134@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 05, 2011 at 05:32:59PM +0000, Matthew Garrett wrote:
> On Sat, Feb 05, 2011 at 07:18:07PM +0200, Felipe Balbi wrote:
> 
> > [  393.020537] dell-wmi: Received unknown WMI event (0x11)
> > [  832.336855] dell-wmi: Received unknown WMI event (0x11)
> > [  832.409353] dell-wmi: Received unknown WMI event (0x11)
> > [  833.621140] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> > [  834.367611] dell-wmi: Received unknown WMI event (0x11)
> > [ 1001.665940] dell-wmi: Received unknown WMI event (0x11)
> > [ 1002.846845] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> > [ 1003.591459] dell-wmi: Received unknown WMI event (0x11)
> > [ 1063.690326] dell-wmi: Received unknown WMI event (0x11)
> > [ 1064.942777] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> > [ 1644.787491] dell-wmi: Received unknown WMI event (0x11)
> > [ 1644.849026] dell-wmi: Received unknown WMI event (0x11)
> > [ 1645.971790] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> > [ 1646.719084] dell-wmi: Received unknown WMI event (0x11)
> > [ 2317.273481] dell-wmi: Received unknown WMI event (0x11)
> > [ 2318.540645] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> > [ 2319.285487] dell-wmi: Received unknown WMI event (0x11)
> > [ 2379.364740] dell-wmi: Received unknown WMI event (0x11)
> > [ 2877.001258] dell-wmi: Received unknown WMI event (0x11)
> > [ 2878.211188] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> > [ 2878.957282] dell-wmi: Received unknown WMI event (0x11)
> > [ 2903.422959] dell-wmi: Received unknown WMI event (0x11)
> > [ 2904.609272] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> > [ 2905.352451] dell-wmi: Received unknown WMI event (0x11)
> > [ 2965.454915] dell-wmi: Received unknown WMI event (0x11)
> > [ 2966.701330] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> > [ 3981.339257] dell-wmi: Received unknown WMI event (0x11)
> > [ 3982.510612] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> > [ 3983.254770] dell-wmi: Received unknown WMI event (0x11)
> > [ 4045.466929] dell-wmi: Received unknown WMI event (0x11)
> > [ 4046.631137] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> > [ 4047.391614] dell-wmi: Received unknown WMI event (0x11)
> > [ 4107.480071] dell-wmi: Received unknown WMI event (0x11)
> > [ 4108.631339] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> > [ 4731.506881] dell-wmi: Received unknown WMI event (0x11)
> > [ 4732.646424] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
> > [ 4733.391238] dell-wmi: Received unknown WMI event (0x11)
> > [ 6025.385179] cdrom: This disc doesn't have any tracks I recognize!
> 
> Nothing's changed in dell-wmi in that timeframe, so I suspect it's some 
> other issue that's triggering here and the hardware is responding by 
> sending events? Alternatively, these messages are pretty spread out. Do 
> they directly correspond to you trying to burn something?

it's actually right after inserting a disc on the drive. I'll try
switching to AHCI on BIOS and see if it works fine.

-- 
balbi
