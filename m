Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab0GUFUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:20:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53621 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab0GUEw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=t/4BMKq4jIidFeTdVySZjlvbIqL6PqJ4PP/N0sHd7bmbqrsQDfFfbf651xphr8dd51
         CRsDlIS9LaNw4q8XQOOpELcZ9G2NXLBZZ9cd2mQ2WZXhUa6d7iMRA9gRudhBZVqR8ZVw
         YPjmbbDOwg4ipLXfhnha5pKigMhsQaQtaqhIo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 27/27]Documentation/dvb/get_dvb_firmware update web address.
Date: Tue, 20 Jul 2010 21:52:03 -0700
Message-Id: <1279687926-29360-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below adds a web address until somebody can really go through
this scripts and make sure these addresses are working.
(will do but not today...)

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/dvb/get_dvb_firmware |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 239cbdb..784cba2 100644
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -18,6 +18,10 @@
 #       along with this program; if not, write to the Free Software
 #       Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
+# Note: some web address are broken with the scripts, if you know of the
+# locations please send out a patch if possible. here is a location for some 
+# firmware http://www.linuxtv.org/downloads/firmware/
+
 use File::Temp qw/ tempdir /;
 use IO::Handle;
 
-- 
1.7.1.rc1.21.gf3bd6

