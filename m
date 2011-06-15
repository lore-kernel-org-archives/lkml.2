Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab1FPHBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:04 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45260 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579Ab1FPHAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:46 -0400
X-Sasl-enc: g+UK4qulMm+aXjWR7/6DHIQISBA2hJmZsohzkxNkzxaH 1308207645
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:32 2011
Message-Id: <20110616000232.047191770@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joe Perches <joe@perches.com>, Matthew Garrett <mjg@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [31/89] asus-wmi: Remove __init from asus_wmi_platform_init
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joe Perches <joe@perches.com>

commit 39ddf3bf6463bc86041e806b43e014d50a144aa4 upstream.

It's used by a non-init function.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/asus-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1223,7 +1223,7 @@ static int asus_wmi_sysfs_init(struct pl
 /*
  * Platform device
  */
-static int __init asus_wmi_platform_init(struct asus_wmi *asus)
+static int asus_wmi_platform_init(struct asus_wmi *asus)
 {
 	int rv;
 


