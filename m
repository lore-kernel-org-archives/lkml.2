Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab0HLSJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 14:09:25 -0400
Received: from lo.gmane.org ([80.91.229.12]:34897 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab0HLSJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 14:09:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: [BISECTED] Removing BKL causes stack trace during early bootup
Date: Thu, 12 Aug 2010 11:09:03 -0700
Message-ID: <4C6438BF.9070608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis>
X-Gmane-NNTP-Posting-Host: adsl-69-234-182-12.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b4pre) Gecko/20100809 Shredder/3.2a1pre
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys.  This commit produces a non-fatal call trace very early during boot
on my dual-CPU amd64 machine (but not on my single-CPU x86):

commit 5e3d20a68f63fc5a310687d81956c3b96e488b84
Author: Arnd Bergmann <arnd@xxxx.de>
Date:   Sun Jul 4 00:02:26 2010 +0200

     init: Remove the BKL from startup code

The trace whizzes by so fast that I can't read it, and the trace doesn't appear
in any of the logs.  Is there a way to capture such a trace, like maybe changing
it to a fatal error?

Thanks!


