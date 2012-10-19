Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030443Ab2JSOcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:32:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487Ab2JSOch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:32:37 -0400
From: joseph.salisbury@canonical.com
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, perex@perex.cz, tiwai@suse.de,
        david.henningsson@canonical.com, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH 0/1] ALSA: hda - add quirk for Thinkpad T430 
Date: Fri, 19 Oct 2012 10:32:29 -0400
Message-Id: <cover.1350570761.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Salisbury <joseph.salisbury@canonical.com>

BugLink: https://bugs.launchpad.net/bugs/1060372

This patch is to enable audio on T430 Thinkpads.  There is no audo from the headphone jack without this patch.  This patch adds a quirk for the T430 model.  


== Test Case ==
A test kernel was built with this patch and tested by a bug reporter at the following bug: 
BugLink: https://bugs.launchpad.net/bugs/1060372



Joseph Salisbury (1):
  ALSA: hda - add quirk for Thinkpad T430

 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

-- 
1.7.9.5

