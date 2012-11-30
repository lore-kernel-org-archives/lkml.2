Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992547Ab2K3SyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:54:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:57567 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031693Ab2K3Stl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Merlin Schumacher <merlin.schumacher@gmail.com>,
        Ike Panhc <ike.pan@canonical.com>, Matthew Garrett <mjg@redhat.com>,
        maximilian attems <max@stro.at>
Subject: [ 34/37] acer-wmi: support for P key on TM8372
Date: Fri, 30 Nov 2012 10:46:21 -0800
Message-Id: <20121130183900.904329144@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Merlin Schumacher <merlin.schumacher@gmail.com>

commit 67e1d34cd54cbf33f093f1dd53e7bda1124eb972 upstream.

BugLink: http://launchpad.net/bugs/865807

There is no entry for P key on TM8372, so when P key is pressed, only
"acer_wmi: Unknown key number - 0x29" in dmesg.

Signed-off-by: Merlin Schumacher <merlin.schumacher@gmail.com>
Signed-off-by: Ike Panhc <ike.pan@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/acer-wmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -104,6 +104,7 @@ static const struct key_entry acer_wmi_k
 	{KE_KEY, 0x22, {KEY_PROG2} },    /* Arcade */
 	{KE_KEY, 0x23, {KEY_PROG3} },    /* P_Key */
 	{KE_KEY, 0x24, {KEY_PROG4} },    /* Social networking_Key */
+	{KE_KEY, 0x29, {KEY_PROG3} },    /* P_Key for TM8372 */
 	{KE_IGNORE, 0x41, {KEY_MUTE} },
 	{KE_IGNORE, 0x42, {KEY_PREVIOUSSONG} },
 	{KE_IGNORE, 0x43, {KEY_NEXTSONG} },


