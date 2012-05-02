Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2EBP4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:56:16 -0400
Received: from flusers.ccur.com ([173.221.59.2]:52926 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754347Ab2EBP4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:56:15 -0400
Date: Wed, 2 May 2012 11:56:13 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch: brackets around single statements fix
Message-ID: <20120502155613.GA27232@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20120502151046.GA25573@tsunami.ccur.com>
 <20120502153212.GE3364@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502153212.GE3364@shadowen.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:32:12AM -0400, Andy Whitcroft wrote:
> On Wed, May 02, 2012 at 11:10:46AM -0400, Joe Korty wrote:
> Interesting.  Got an example I can use to add to the test suite.



Test case for scripts/checkpatch.pl: thinks '#else'
is the same as 'else', prints an error for brackets
around single statements.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

--- /tmp/y.c	2012-05-02 11:53:28.000000000 -0400
+++ /tmp/x.c	2012-05-02 11:52:28.000000000 -0400
@@ -1,6 +1,10 @@
 struct abc abc = {
 	{ a, "a " },
 	{ b, "b " },
+#ifdef CONFIG_REPURPOSE
+	{ d, "d " },
+#else
 	{ c, "c " },
+#endif
 	{ },
 };
