Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0HWJ7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:59:43 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:56953 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747Ab0HWJ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:59:40 -0400
Date: Mon, 23 Aug 2010 11:59:33 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Daniel Mack <daniel@caiaq.de>, Joseph Chan <JosephChan@via.com.tw>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Erik-Jan Post <ej.lfs@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 0/2] Removing dead code
Message-ID: <cover.1282554255.git.qy03fugy@stud.informatik.uni-erlangen.de>
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

        I've been running a check on the drivers/video sourcetree for
config Items not defined in Kconfig and found 2 such cases. Sourcecode
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

Christian Dietrich (2):
  drivers/video: Removing dead FB_VIA_CAMERA config option
  drivers/video: Removing dead FB_68328_INVERT config option

 drivers/video/68328fb.c   |    4 ----
 drivers/video/via/accel.c |   16 ----------------
 include/linux/via-core.h  |    5 +----
 3 files changed, 1 insertions(+), 24 deletions(-)

