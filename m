Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab2LCOoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:44:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43893 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465Ab2LCOgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:52 -0500
Message-Id: <20121203143153.423055659@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:28 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Merlin Schumacher <merlin.schumacher@gmail.com>,
        Ike Panhc <ike.pan@canonical.com>, Matthew Garrett <mjg@redhat.com>
Subject: [ 42/89] acer-wmi: support for P key on TM8372
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Merlin Schumacher <merlin.schumacher@gmail.com>

commit 67e1d34cd54cbf33f093f1dd53e7bda1124eb972 upstream.

BugLink: http://launchpad.net/bugs/865807

There is no entry for P key on TM8372, so when P key is pressed, only
"acer_wmi: Unknown key number - 0x29" in dmesg.

Signed-off-by: Merlin Schumacher <merlin.schumacher@gmail.com>
Signed-off-by: Ike Panhc <ike.pan@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/acer-wmi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 7203e06..286dd9c 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -105,6 +105,7 @@ static const struct key_entry acer_wmi_keymap[] = {
 	{KE_KEY, 0x22, {KEY_PROG2} },    /* Arcade */
 	{KE_KEY, 0x23, {KEY_PROG3} },    /* P_Key */
 	{KE_KEY, 0x24, {KEY_PROG4} },    /* Social networking_Key */
+	{KE_KEY, 0x29, {KEY_PROG3} },    /* P_Key for TM8372 */
 	{KE_IGNORE, 0x41, {KEY_MUTE} },
 	{KE_IGNORE, 0x42, {KEY_PREVIOUSSONG} },
 	{KE_IGNORE, 0x43, {KEY_NEXTSONG} },


