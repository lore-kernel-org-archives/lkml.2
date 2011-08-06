Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab1HFVpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 17:45:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57203 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab1HFVpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 17:45:40 -0400
Message-ID: <4E3DB600.4070204@gmail.com>
Date: Sat, 06 Aug 2011 22:45:36 +0100
From: Paul Mcquade <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Email-clients: Add better Thunderbird information.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Email-clients: Add better Thunderbird information.

Add Thunderbird Registry instructions to:
Enable UTF8 & Preformat mode
Disable HTML mode

Fwd: From 'linux-doc' mailing list
Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---

 Documentation/email-clients.txt |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
index a0b58e2..860c29a 100644
--- a/Documentation/email-clients.txt
+++ b/Documentation/email-clients.txt
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
-- 1.7.4.1


