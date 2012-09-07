Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab2IGUd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 16:33:58 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36801 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2IGUd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 16:33:57 -0400
From: Jon Stanley <jonstanley@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jon Stanley <jonstanley@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/2] Update FSF postal address to be URL's.
Date: Fri,  7 Sep 2012 16:32:46 -0400
Message-Id: <1347049967-3143-1-git-send-email-jonstanley@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSF now prefers to use URL's in copyright headers rather than
their postal address. This change updates the address to be
<http://www.gnu.org/licenses> per http://www.gnu.org/licenses/gpl-howto.html

Signed-off-by: Jon Stanley <jonstanley@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c  |    3 +--
 tools/lib/traceevent/event-parse.h  |    3 +--
 tools/lib/traceevent/event-utils.h  |    3 +--
 tools/lib/traceevent/parse-filter.c |    3 +--
 tools/lib/traceevent/trace-seq.c    |    3 +--
 5 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5f34aa3..7b946f9 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -13,8 +13,7 @@
  * GNU Lesser General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 5772ad8..ea93a1a 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -13,8 +13,7 @@
  * GNU Lesser General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
diff --git a/tools/lib/traceevent/event-utils.h b/tools/lib/traceevent/event-utils.h
index 0829638..ebd970c 100644
--- a/tools/lib/traceevent/event-utils.h
+++ b/tools/lib/traceevent/event-utils.h
@@ -13,8 +13,7 @@
  * GNU Lesser General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index ad17855..5527c32 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -13,8 +13,7 @@
  * GNU Lesser General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index b1ccc92..a57db80 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -13,8 +13,7 @@
  * GNU Lesser General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
-- 
1.7.1

