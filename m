Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0GUMea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:34:30 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58163 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670Ab0GUMe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:34:28 -0400
Date: Wed, 21 Jul 2010 14:34:24 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, Julia Lawall <julia@diku.dk>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 0/3] Removing dead code
Message-ID: <cover.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
       
        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

        I've been running a check on the sound/ sourcetree for
config Items not defined in Kconfig and found 3 such cases. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

        Each of the patches in this patchset removes on such dead
config Item, I'd be glad if you consider applying them. I've been
doing deeper analysis of such issues before and can do so again but
I'm not so sure they were fastly usefull.

        I build the patches against a vanilla kernel in order to
try if the kernel compiles with this patches

        Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

        Christian Dietrich

[0] http://vamos1.informatik.uni-erlangen.de/

Christian Dietrich (3):
  sound/oss: Remove dead CONFIG_SOFTOSS*
  sound/soc/atmel: Remove dead CONFIG_AT32_ENHANCED_PORTMUX
  sound/isa/gus: Remove dead CONFIG_SND_DEBUG_ROM

 sound/isa/gus/interwave.c        |    8 --------
 sound/oss/vidc.c                 |    3 ---
 sound/soc/atmel/playpaq_wm8510.c |    9 ---------
 3 files changed, 0 insertions(+), 20 deletions(-)

