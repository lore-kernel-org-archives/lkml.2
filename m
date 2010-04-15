Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab0DOUac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 16:30:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47215 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab0DOUab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 16:30:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 15 Apr 2010 22:30:08 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [git pull] FireWire fixes and documentation update
To: "Daniel K." <dk@uw.no>, Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <4BC76BDD.1020509@uw.no>
Message-ID: <tkrat.abecf43dc6ad55ec@s5r6.in-berlin.de>
References: <tkrat.671196999e56464f@s5r6.in-berlin.de>
 <tkrat.e3130c87f5d2851a@s5r6.in-berlin.de>
 <tkrat.66ea5df34ac46da2@s5r6.in-berlin.de>
 <tkrat.fecd1b8fd085f0f8@s5r6.in-berlin.de> <4BC76BDD.1020509@uw.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Apr, Daniel K. wrote:
> Stefan Richter wrote:
>>     firewire: cdev: change license of exported header files to MIT license
>> [...]
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
>> + * PRECISION INSIGHT AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
> 
> Where exactly does PRECISION INSIGHT AND/OR ITS SUPPLIERS enter the picture?
> Are any of you employed there?

No, this was a copy & waste error.
Thanks, fixed.

Linus, I updated linux1394-2.6.git's for-linus branch for you to pull:

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

Clemens Ladisch (3):
      firewire: cdev: disallow receive packets without header
      firewire: cdev: require quadlet-aligned headers for transmit packets
      firewire: cdev: iso packet documentation

Stefan Richter (4):
      firewire: cdev: fix information leak
      firewire: cdev: comment fixlet
      firewire: cdev: change license of exported header files to MIT license
      firewire: cdev: fix cut+paste mistake in disclaimer

 drivers/firewire/core-cdev.c       |   23 ++++++-----
 include/linux/firewire-cdev.h      |   78 +++++++++++++++++++++++++-----------
 include/linux/firewire-constants.h |   29 ++++++++++++-
 3 files changed, 95 insertions(+), 35 deletions(-)


Added:

>From a2612cb16d4d8447793609cbdd2a2f4f156c0020 Mon Sep 17 00:00:00 2001
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Thu, 15 Apr 2010 22:16:04 +0200
Subject: [PATCH] firewire: cdev: fix cut+paste mistake in disclaimer

This was supposed to be generic "authors or copyright holders";
I mistakenly picked up text from a wrong file.

Reported-by: Daniel K. <dk@uw.no>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/linux/firewire-cdev.h      |    2 +-
 include/linux/firewire-constants.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index 81f3b14..68f883b 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -17,7 +17,7 @@
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * PRECISION INSIGHT AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
  * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  * DEALINGS IN THE SOFTWARE.
diff --git a/include/linux/firewire-constants.h b/include/linux/firewire-constants.h
index 9c63f06..9b4bb5f 100644
--- a/include/linux/firewire-constants.h
+++ b/include/linux/firewire-constants.h
@@ -17,7 +17,7 @@
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * PRECISION INSIGHT AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
  * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  * DEALINGS IN THE SOFTWARE.
-- 
Stefan Richter
-=====-==-=- -=-- -====
http://arcgraph.de/sr/

