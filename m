Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977Ab0FRLIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 07:08:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:58130 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760967Ab0FRLH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 07:07:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=gR5cIyRdPFqtcGriyqQ6YaE+iBGqN6afL7mi3hLs8tJjw3DMd6mLdvtYJ2NggJcUpe
         SdBa1b/F2K1bUYkNyi16WDEmz5diTaG5aermgHMSwJxtlOoaJt9do4oSYmLUEe128MRf
         QLIGuSYp8aHOtuqvJY8dfKR/KATbenxSCNIHU=
Subject: [PATCH] Documentation/sysctl/vm.txt typo
From: Kulikov Vasiliy <segooon@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 15:07:50 +0400
Message-ID: <1276859270.3159.5.camel@shinshilla>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trivial typo: duplicated word.

--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -196,7 +196,7 @@ controlled by this knob are discussed in
Documentation/laptops/laptop-mode.txt.
 
 legacy_va_layout
 
-If non-zero, this sysctl disables the new 32-bit mmap mmap layout - the
kernel
+If non-zero, this sysctl disables the new 32-bit mmap layout - the
kernel
 will use the legacy (2.4) layout for all processes.
 
 ==============================================================


