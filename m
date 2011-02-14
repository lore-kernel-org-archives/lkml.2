Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab1BNWrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:47:43 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12047 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1BNWrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:47:20 -0500
Date: Mon, 14 Feb 2011 23:46:17 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: {PATCH][trivial] serial, pch uart: Remove duplicate inclusion of
 linux/pci.h header
Message-ID: <alpine.LNX.2.00.1102142343550.4530@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only include linux/pci.h once in drivers/tty/serial/pch_uart.c

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 pch_uart.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 3b2fb93..14a27c3 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -15,7 +15,6 @@
  *Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
  */
 #include <linux/serial_reg.h>
-#include <linux/pci.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/serial_core.h>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

