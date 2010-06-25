Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0FYLIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:08:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60197 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0FYLIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:08:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HPcS/XufPKflKFZDbs3TUl3ODEffXVgbCTePGd4FUcopzBTvfg/8+Splf5pACUW2lk
         JnXEOnbt8RVa59+IuFbqGZpIE4KEOzUjHMIwZPvmFnSgZuqzkWiR0X7XTp9cvZC3mVyF
         67yGMU+Lmun6Fv92+73qHgULrbMmTHZQAXIJk=
Date: Fri, 25 Jun 2010 15:08:01 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Nick Bowler <nbowler@elliptictech.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: [PATCH v2] Documentation/sysctl/vm.txt typo
Message-ID: <20100625110801.GB6896@shinshilla>
References: <1276859270.3159.5.camel@shinshilla>
 <20100618142252.GA31086@elliptictech.com>
 <20100618154033.1e949749.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618154033.1e949749.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trivial typo: duplicated word.

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 5fdbb61..82b2da1 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -196,7 +196,7 @@ controlled by this knob are discussed in Documentation/laptops/laptop-mode.txt.
 
 legacy_va_layout
 
-If non-zero, this sysctl disables the new 32-bit mmap mmap layout - the kernel
+If non-zero, this sysctl disables the new 32-bit mmap layout - the kernel
 will use the legacy (2.4) layout for all processes.
 
 ==============================================================
