Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab0LTNjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:39:51 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:36793 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab0LTNju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:39:50 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        Chase Douglas <chase.douglas@canonical.com>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v2 0/3] Input: synaptics - add semi-mt support
Date: Mon, 20 Dec 2010 14:39:21 +0100
Message-Id: <1292852364-19127-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.2.3
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PUfxk-00080m-7C.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PUfxk-00080m-7C 891566eb6638efeda0586ccb7c48ca69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

So I ended up modifying the first patch, after all, implementing
Dmitry's comments. The patch did shrink a bit, and it it is still to
be signed off by the original authors, if you please.

Testing seems ok on my local machine, and I put a dkms out in the wild
to capture any oddities. Otherwise, the patches are doing exactly the
same thing as before.

Takashi, Chase, Chris?

Thanks,
Henrik

Henrik Rydberg (3):
  Input: synaptics - report clickpad property
  Input: synaptics - add multi-finger and semi-mt support
  Input: synaptics - ignore bogus mt packet

 drivers/input/mouse/synaptics.c |   95 ++++++++++++++++++++++++++++++++++++--
 drivers/input/mouse/synaptics.h |    3 +
 2 files changed, 93 insertions(+), 5 deletions(-)

-- 
1.7.2.3

