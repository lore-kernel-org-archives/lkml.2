Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1COXL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:11:59 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:58165 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755844Ab1COXLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:11:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UO1WXSKMlyH6DgDtL8eUz6KGwhxSSHkTrhd5M7M8R4aTr5HuXoIUUWWuptQ4slReS4kcsTfpDMgF7pl2gen7jCAph6ivkBrYqqjif//SnpEuYkiVhiLMfnh73Kfyx6PA;
Date: Tue, 15 Mar 2011 16:11:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Roland Kammerer <dev.rck@gmail.com>
Subject: [PATCH 3/6] Documentation: update header filename in CodingStyle
Message-Id: <20110315161152.4bee194f.rdunlap@xenotime.net>
In-Reply-To: <20110315134316.465b6e2c.rdunlap@xenotime.net>
References: <20110315134316.465b6e2c.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Kammerer <dev.rck@gmail.com>

pr_info() and pr_debug() are in linux/printk.h, not linux/kernel.h.
Last updated is unnecessary, we have git for that.

Signed-off-by: Roland Kammerer <dev.rck@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/CodingStyle |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- lnx-2638-rc8.orig/Documentation/CodingStyle
+++ lnx-2638-rc8/Documentation/CodingStyle
@@ -659,7 +659,7 @@ There are a number of driver model diagn
 which you should use to make sure messages are matched to the right device
 and driver, and are tagged with the right level:  dev_err(), dev_warn(),
 dev_info(), and so forth.  For messages that aren't associated with a
-particular device, <linux/kernel.h> defines pr_debug() and pr_info().
+particular device, <linux/printk.h> defines pr_debug() and pr_info().
 
 Coming up with good debugging messages can be quite a challenge; and once
 you have them, they can be a huge help for remote troubleshooting.  Such
@@ -819,6 +819,3 @@ language C, URL: http://www.open-std.org
 Kernel CodingStyle, by greg@kroah.com at OLS 2002:
 http://www.kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/
 
---
-Last updated on 2007-July-13.
-
