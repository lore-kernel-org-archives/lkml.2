Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1HMTgD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 15:36:03 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:53609 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752441Ab1HMTfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 15:35:20 -0400
Date: Sat, 13 Aug 2011 12:34:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Paul McQuade <paulmcquad@gmail.com>
Subject: [PATCH 5/8] Documentation: email-clients: Add better Thunderbird
 information
Message-Id: <20110813123454.26e52722.rdunlap@xenotime.net>
In-Reply-To: <20110813122200.8e2fc879.rdunlap@xenotime.net>
References: <20110813122200.8e2fc879.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mcquade <paulmcquad@gmail.com>

Add better Thunderbird information.
Add Thunderbird Registry instructions to:
Enable UTF8 & Preformat mode
Disable HTML mode

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/email-clients.txt |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- lnx-31-rc1-git7.orig/Documentation/email-clients.txt
+++ lnx-31-rc1-git7/Documentation/email-clients.txt
@@ -199,18 +199,16 @@ to coerce it into behaving.
 
 To beat some sense out of the internal editor, do this:
 
-- Under account settings, composition and addressing, uncheck "Compose
-  messages in HTML format".
-
 - Edit your Thunderbird config settings so that it won't use format=flowed.
   Go to "edit->preferences->advanced->config editor" to bring up the
   thunderbird's registry editor, and set "mailnews.send_plaintext_flowed" to
   "false".
 
-- Enable "preformat" mode: Shft-click on the Write icon to bring up the HTML
-  composer, select "Preformat" from the drop-down box just under the subject
-  line, then close the message without saving.  (This setting also applies to
-  the text composer, but the only control for it is in the HTML composer.)
+- Disable HTML Format: Set "mail.identity.id1.compose_html" to "false".
+
+- Enable "preformat" mode: Set "editor.quotesPreformatted" to "true".
+
+- Enable UTF8: Set "prefs.converted-to-utf8" to "true".
 
 - Install the "toggle wordwrap" extension.  Download the file from:
     https://addons.mozilla.org/thunderbird/addon/2351/
