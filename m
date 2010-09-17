Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab0IQPuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:50:09 -0400
Received: from mail.tpi.com ([70.99.223.143]:4913 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab0IQPuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:50:08 -0400
X-Greylist: delayed 1752 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Sep 2010 11:50:08 EDT
From: Tim Gardner <tim.gardner@canonical.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Tim Gardner <tim.gardner@canonical.com>,
        Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>
Subject: [PATCH] staging: brcm80211: Make CFLAGS explicit
Date: Fri, 17 Sep 2010 09:20:10 -0600
Message-Id: <1284736810-2940-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its too easy to confuse the obscurely named WLC_LOW/WLC_HIGH CFLAG
macros.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Nohee Ko <noheek@broadcom.com>
---
 drivers/staging/brcm80211/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/Makefile b/drivers/staging/brcm80211/Makefile
index 05a4103..7a77e7f 100644
--- a/drivers/staging/brcm80211/Makefile
+++ b/drivers/staging/brcm80211/Makefile
@@ -15,8 +15,9 @@
 # OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
-EXTRA_CFLAGS := -DBCMDBG -DWLC_HIGH -DSTA -DWME -DWL11N -DDBAND -DBCMDMA32 -DBCMNVRAMR -Idrivers/staging/brcm80211/sys -Idrivers/staging/brcm80211/phy -Idrivers/staging/brcm80211/util -Idrivers/staging/brcm80211/include -Wall -Wstrict-prototypes -Werror -Wmissing-prototypes
+EXTRA_CFLAGS := -DBCMDBG -DWME -DWL11N -DDBAND -DBCMDMA32 -DBCMNVRAMR -Idrivers/staging/brcm80211/sys -Idrivers/staging/brcm80211/phy -Idrivers/staging/brcm80211/util -Idrivers/staging/brcm80211/include -Wall -Wstrict-prototypes -Werror -Wmissing-prototypes
 
+USB_CFLAGS := -DWLC_HIGH
 PCI_CFLAGS := -DWLC_LOW
 
 BRCM80211_OFILES := \
-- 
1.7.0.4

