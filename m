Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1CPPgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:36:46 -0400
Received: from linux-sh.org ([111.68.239.195]:34238 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab1CPPgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:36:40 -0400
Date: Thu, 17 Mar 2011 00:36:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Heiko Schocher <hs@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH 3/4 v5] video, sm501: add OF binding to support SM501
Message-ID: <20110316153601.GA13315@linux-sh.org>
References: <1291451028-22532-1-git-send-email-hs@denx.de> <1296026490-14665-1-git-send-email-hs@denx.de> <4D7F14B0.1030008@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7F14B0.1030008@denx.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 08:26:40AM +0100, Heiko Schocher wrote:
> > 0003-video-sm501-add-OF-binding-to-support-SM501.patch has no obvious style problems and is ready for submission.
> > 
> >  Documentation/powerpc/dts-bindings/sm501.txt |   34 +++++++++++++++++++++
> >  drivers/mfd/sm501.c                          |    9 +++++-
> >  drivers/video/sm501fb.c                      |   42 ++++++++++++++++++++++++--
> >  3 files changed, 81 insertions(+), 4 deletions(-)
> >  create mode 100644 Documentation/powerpc/dts-bindings/sm501.txt
> 
> This patchset is pending know for a while. I got Acked by from
> 
> Samuel Ortiz for the mfd part, see here:
> 
> http://www.spinics.net/lists/linux-fbdev/msg02550.html
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2011-01/msg11798.html
> 
> and for the DTS part from Benjamin Herrenschmidt:
> 
> http://lists.ozlabs.org/pipermail/linuxppc-dev/2011-February/088279.html
> 
> Are there some more issues?
> 
Not that I remember off the top of my head, but I think they've been lost
in my backlog. Could you re-send the current series with the appropriate
acked-bys? If there's nothing else obvious outstanding I'll roll them in.
