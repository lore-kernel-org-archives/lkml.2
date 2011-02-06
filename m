Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1BFRpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 12:45:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45142 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1BFRpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 12:45:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=wMpkSViE+eEcR9DEDcE93Pf8PcIbgu5G6oCsm2GEc0aow8mcrLEZWRbchIKVQ3ubnX
         D9++1PohjHVru5GdegrSvMoqpyClQE72HNLHc73VmmdUJ2dtDl4hj3U/3eZJZk0E/shI
         +fCp/P6nTwwMHY4EJ9HhFzVzskmUaMvwm0v48=
Date: Sun, 6 Feb 2011 19:45:04 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH -next] Documentation: Explain the [KMG] parameters suffix
Message-ID: <20110206174504.GA23024@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Also applicable over 2.6.38-rc3)

The '[KMG]' suffix is commonly described after a number of kernel
parameter values documentation.  Explicitly state its semantics.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 89835a4..3deedce 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -144,6 +144,11 @@ a fixed number of characters. This limit depends on the architecture
 and is between 256 and 4096 characters. It is defined in the file
 ./include/asm/setup.h as COMMAND_LINE_SIZE.
 
+Finally, the [KMG] suffix is commonly described after a number of kernel
+parameter values. These 'K', 'M', and 'G' letters represent the _binary_
+multipliers 'Kilo', 'Mega', and 'Giga', equalling 2^10, 2^20, and 2^30
+bytes respectively. Such letter suffixes can also be entirely omitted.
+
 
 	acpi=		[HW,ACPI,X86]
 			Advanced Configuration and Power Interface

regards,

-- 
Darwish
http://darwish.07.googlepages.com
