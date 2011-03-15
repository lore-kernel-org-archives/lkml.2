Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1COH0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 03:26:50 -0400
Received: from b.relay.invitel.net ([62.77.203.4]:35429 "EHLO
	b.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab1COH0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 03:26:47 -0400
Date: Tue, 15 Mar 2011 08:26:40 +0100
From: Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH 3/4 v5] video, sm501: add OF binding to support SM501
In-reply-to: <1296026490-14665-1-git-send-email-hs@denx.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-fbdev@vger.kernel.org, devicetree-discuss@ozlabs.org,
        Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Paul Mundt <lethal@linux-sh.org>,
        Wolfgang Denk <wd@denx.de>
Reply-to: hs@denx.de
Message-id: <4D7F14B0.1030008@denx.de>
Organization: DENX Software Engineering
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1296026490-14665-1-git-send-email-hs@denx.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Heiko Schocher wrote:
> - add binding to OF, compatible name "smi,sm501"
> 
> Signed-off-by: Heiko Schocher <hs@denx.de>
> cc: linux-fbdev@vger.kernel.org
> cc: devicetree-discuss@ozlabs.org
> cc: Ben Dooks <ben@simtec.co.uk>
> cc: Vincent Sanders <vince@simtec.co.uk>
> cc: Samuel Ortiz <sameo@linux.intel.com>
> cc: linux-kernel@vger.kernel.org
> cc: Randy Dunlap <rdunlap@xenotime.net>
> cc: Paul Mundt <lethal@linux-sh.org>
> 
> ---
> - changes since v1:
>   add Ben Dooks, Vincent Sanders and Samuel Ortiz to cc, as suggested from
>   Paul Mundt.
> - changes since v2:
>   add comments from Randy Dunlap:
>   - move parameter documentation to Documentation/fb/sm501.txt
> - changes since v3:
>   - rebased against v2.6.38-rc2
>   - split in 3 patches
>     - of support patch
>       - get rid of "#if defined(CONFIG_PPC_MPC52xx)" usage
>         hide this in DTS, as Paul suggested.
>     - i/o routine patch
>     - edid support patch
> - changes since v4
>   replace remaining CONFIG_PPC_MPC52xx with CONFIG_OF, as
>   it is no longer MPC52xx only.
> - changes since v5
>   free edid_data after its usage, as it is no longer needed,
>   suggested from Paul Mundt. Also fall back to default if
>   kmemdup(edid_data) fails.
> 
> ./scripts/checkpatch.pl 0003-video-sm501-add-OF-binding-to-support-SM501.patch
> total: 0 errors, 0 warnings, 132 lines checked
> 
> 0003-video-sm501-add-OF-binding-to-support-SM501.patch has no obvious style problems and is ready for submission.
> 
>  Documentation/powerpc/dts-bindings/sm501.txt |   34 +++++++++++++++++++++
>  drivers/mfd/sm501.c                          |    9 +++++-
>  drivers/video/sm501fb.c                      |   42 ++++++++++++++++++++++++--
>  3 files changed, 81 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/powerpc/dts-bindings/sm501.txt

This patchset is pending know for a while. I got Acked by from

Samuel Ortiz for the mfd part, see here:

http://www.spinics.net/lists/linux-fbdev/msg02550.html
http://linux.derkeiler.com/Mailing-Lists/Kernel/2011-01/msg11798.html

and for the DTS part from Benjamin Herrenschmidt:

http://lists.ozlabs.org/pipermail/linuxppc-dev/2011-February/088279.html

Are there some more issues?

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
