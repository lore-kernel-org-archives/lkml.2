Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab1JRDeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 23:34:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36885 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1JRDeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 23:34:08 -0400
X-Authority-Analysis: v=1.1 cv=Aw1K5MWCW/IlYLbVHOK2DHmxtnIeftPoAvmBFvlQMWA= c=1 sm=0 a=TRwAYCZYi8oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=Sy0NQmMnAAAA:8 a=1XWaLZrsAAAA:8 a=i07kJe7l_IeLekVaSxcA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZJmIAeVxK1QA:10 a=UTB_XpHje0EA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318908846.4441.2.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL] m32r: Allow use of atomic64
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Hirokazu Takata <takata@linux-m32r.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 17 Oct 2011 23:34:06 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: abcefec31e3dc46554ee9c04f70c6012b17e8dc5


Steven Rostedt (1):
      m32r: Allow use of atomic64

----
 arch/m32r/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
---------------------------
commit abcefec31e3dc46554ee9c04f70c6012b17e8dc5
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Thu Oct 13 10:40:16 2011 -0400

    m32r: Allow use of atomic64
    
    Atomic64 is now a valid type in Linux. Archs that do not have their own
    version of atomic64 operators are to use the generic operations.
    
    The m32r architecture needs to define GENERIC_ATOMIC64.
    
    Link: http://lkml.kernel.org/r/20111013085936.GA13046@elte.hu
    Link: http://lkml.kernel.org/r/1318516816.12224.12.camel@gandalf.stny.rr.com
    Link: http://lkml.kernel.org/r/20111017185440.GB5545@elte.hu
    
    Acked-by: Hirokazu Takata <takata@linux-m32r.org>
    Acked-by: David Rientjes <rientjes@google.com>
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index b92b944..6c4e9aa 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -10,6 +10,7 @@ config M32R
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_ATOMIC64
 
 config SBUS
 	bool


