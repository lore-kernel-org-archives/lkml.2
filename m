Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab1EFAOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:14:40 -0400
Received: from kroah.org ([198.145.64.141]:32976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab1EFANm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:10 2011
Message-Id: <20110506001210.810495759@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:11:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jarod Wilson <jarod@wilsonet.com>,
        Lawrence Rust <lawrence@softsystem.co.uk>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Lawrence Rust <lvr@softsystem.dot.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 36/38] [media] cx88: Fix HVR4000 IR keymap
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lawrence Rust <lvr@softsystem.dot.uk>

[fixed in .39 in a much different way that is too big to backport to
.38 - gregkh]

Fixes the RC key input for Nova-S plus, HVR1100, HVR3000 and HVR4000 in
the 2.6.38 kernel.

Signed-off-by: Lawrence Rust <lvr@softsystem.dot.uk>
Acked-by: Jarod Wilson <jarod@wilsonet.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---
 drivers/media/video/cx88/cx88-input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -283,7 +283,7 @@ int cx88_ir_init(struct cx88_core *core,
 	case CX88_BOARD_PCHDTV_HD3000:
 	case CX88_BOARD_PCHDTV_HD5500:
 	case CX88_BOARD_HAUPPAUGE_IRONLY:
-		ir_codes = RC_MAP_HAUPPAUGE_NEW;
+		ir_codes = RC_MAP_RC5_HAUPPAUGE_NEW;
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:


