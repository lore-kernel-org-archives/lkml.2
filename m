Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab1JXPtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:49:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45170 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932793Ab1JXPtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:49:31 -0400
Message-ID: <1319471369.25101.3.camel@Joe-Laptop>
Subject: [PATCH] MAINTAINERS: Staging: cx25821: Add L: linux-media
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Date: Mon, 24 Oct 2011 08:49:29 -0700
In-Reply-To: <20111024224623.7585c471@inspire>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
	 <20111022081941.GA5443@suse.de> <4EA3A7ED.8090404@redhat.com>
	 <20111023232418.2d79ed12@inspire> <4EA47CF8.2090504@redhat.com>
	 <20111024224623.7585c471@inspire>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Send patches to a mailing list.

Signed-off-by: Joe Perches <joe@perches.com>

---

On Sun, 23 Oct 2011 22:45:44 +0200
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> The better is if you could send them to linux-media@vger.kernel.org. Patchwork
> will catch them and put on my queue automatically.

 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a85a9b7..75d0718 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6262,6 +6262,11 @@ M:	Mori Hess <fmhess@users.sourceforge.net>
 S:	Odd Fixes
 F:	drivers/staging/comedi/
 
+STAGING - CONEXANT CX25821 PCIE BRIDGE
+L:	linux-media@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/staging/cx25821/
+
 STAGING - CRYSTAL HD VIDEO DECODER
 M:	Naren Sankar <nsankar@broadcom.com>
 M:	Jarod Wilson <jarod@wilsonet.com>


