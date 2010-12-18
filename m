Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab0LROyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 09:54:24 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:57953 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756410Ab0LROyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 09:54:21 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Chase Douglas <chase.douglas@canonical.com>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/4] Input: synaptics - add semi-mt support
Date: Sat, 18 Dec 2010 15:52:57 +0100
Message-Id: <1292683981-6908-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.2.3
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTy9q-00006I-7t.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PTy9q-00006I-7t b2f891f20dad5144af3b985365558ec1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is what I hope to be a final version of the synaptics MT
patches. The first patch is unchanged except for a fixed typo. It does
not work very well on some clickpads, but this could arguably be fixed
in userspace. There is a dkms package out there with similar code,
which generally seems to work for people. The second patch fixes an
odd behavior found on my test machine. Does it make a difference to
anyone else? The third patch utilizes the new property interface to
flag the clickpad property. The fourth patch implements the semi-mt
support, this time flagged using the property interface.

Chase, Chris?

Thanks,
Henrik

Chase Douglas (1):
  Input: synaptics - add multitouch packet support

Henrik Rydberg (3):
  Input: synaptics - ignore bogus mt packet
  Input: synaptics - report clickpad property
  Input: synaptics - emit multitouch data

 drivers/input/mouse/synaptics.c |  124 ++++++++++++++++++++++++++++++++++-----
 drivers/input/mouse/synaptics.h |    4 +
 2 files changed, 112 insertions(+), 16 deletions(-)

-- 
1.7.2.3

