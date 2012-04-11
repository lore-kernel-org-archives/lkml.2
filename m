Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807Ab2DLAGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:06:54 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63303 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933661Ab2DKXPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:15:13 -0400
Message-Id: <20120411231022.277118574@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Beulich <jbeulich@suse.com>,
        Michal Marek <mmarek@suse.cz>
Subject: [ 24/78] modpost: fix ALL_INIT_DATA_SECTIONS
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 9aaf440f8fabcebf9ea79a62ccf4c212e6544b49 upstream.

This was lacking a comma between two supposed to be separate strings.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -849,7 +849,7 @@ static void check_section(const char *mo
 
 #define ALL_INIT_DATA_SECTIONS \
 	".init.setup$", ".init.rodata$", \
-	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$" \
+	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$", \
 	".init.data$", ".devinit.data$", ".cpuinit.data$", ".meminit.data$"
 #define ALL_EXIT_DATA_SECTIONS \
 	".exit.data$", ".devexit.data$", ".cpuexit.data$", ".memexit.data$"


