Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0F0DvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 23:51:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34933 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab0F0DvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 23:51:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=a4Uqn0nXnJGut3n/SGGZ3SNk1Wn3dJovBqJo+EnwIb834cv7LbXNk+Dndoqlf8+YQN
         OS1SEtLBkgH2xruzYtzmiNEy8laMsuXGXHVjo0eltuRlXzt++FLnNYzRy00p2+lG2Zn9
         gYhSzrgQk/3JU4c6fD0TbhWOuuIYl3VswAEIM=
Date: Sun, 27 Jun 2010 07:51:06 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Nick Bowler <nbowler@elliptictech.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3] Documentation/sysctl/vm.txt typo
Message-ID: <20100627035106.GA25692@shinshilla>
References: <1276859270.3159.5.camel@shinshilla>
 <20100618142252.GA31086@elliptictech.com>
 <20100618154033.1e949749.rdunlap@xenotime.net>
 <20100625110801.GB6896@shinshilla>
 <AANLkTinu8OkcfANcJAFELtiPXTC9pfJTDsdSXugJ2xN3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinu8OkcfANcJAFELtiPXTC9pfJTDsdSXugJ2xN3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trivial typo: duplicated word.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

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

