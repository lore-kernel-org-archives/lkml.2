Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2DFNeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 09:34:16 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:49760 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843Ab2DFNeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 09:34:15 -0400
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] ALSA: hda - CX20549 cleanup/fixes
Date: Fri,  6 Apr 2012 15:34:14 +0200
Message-Id: <1333719260-14504-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <s5hk41ufe2j.wl%tiwai@suse.de>
References: <s5hk41ufe2j.wl%tiwai@suse.de>
X-Originating-IP: 87.123.69.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the revised patch series for the CX20549 (and related stuff)

Changes:
 Patch 1/6:
  - spec->single_adc_amp has been moved to codec->single_adc_amp
    to fix printing in /proc.
 Patch 2/6: 
  - "Line In" has been changed to "Line".
  - This change has also been performed on the Mixer Labels.
 Patch 4/6:
  - .num_items has been adjusted, too.
  - A comment about physical testing has been added to the commit message.
 Patch 5/6:
  - pin_amp_workaround is not set for CX20549 in auto-setup, too

