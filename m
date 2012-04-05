Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2DENtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 09:49:47 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:38342 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048Ab2DENtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 09:49:43 -0400
X-Greylist: delayed 1206 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2012 09:49:40 EDT
Message-ID: <1333632577.4159.9.camel@localhost>
Subject: [PATCH 0/6] sound/pci/hda: CX20549 cleanup/fixes
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Apr 2012 15:29:37 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Originating-IP: 89.247.230.181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes recording on a Gigabyte W551N laptop that
seems to be identical to the BenW R55E. The Audio Codec uses the same
subsystem ID, which is assigned to Quanta. The Gigabyte laptop is based
on the Quanta TW3 ODM.

(for the whole series)
Signed-Off-By: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>


