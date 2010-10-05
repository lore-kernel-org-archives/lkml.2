Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab0JEPVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:21:15 -0400
Received: from smtp205.alice.it ([82.57.200.101]:35088 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104Ab0JEPVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:21:13 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-input@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>, Jiri Kosina <jkosina@suse.cz>,
        Alan Ott <alan@signal11.us>, Oliver Neukum <oliver@neukum.name>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH 0/2] HID: hidraw, fix two NULL pointer dereferences
Date: Tue,  5 Oct 2010 17:20:15 +0200
Message-Id: <1286292017-6746-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz>
References: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are some fixes to hidraw.

Patches are against 2.6.36-rc6, but they should be ported to other
maintained stable kernels as well.

Antonio Ospite (2):
  HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
  HID: hidraw, fix a NULL pointer dereference in hidraw_write

 drivers/hid/hidraw.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)


The first one has been sent already but I am resending it with
stable@stable@kernel.org in the recipients list.


Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
