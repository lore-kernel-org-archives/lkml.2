Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1FBWVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:21:08 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52574 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab1FBWVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:21:06 -0400
X-Nat-Received: from [202.181.97.72]:59267 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1307053179.22576
To: hmh@hmh.eng.br
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Preparation for Linux 3.0
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201106020350.p523o95o094928@www262.sakura.ne.jp>
	<20110602191101.GC31586@khazad-dum.debian.net>
In-Reply-To: <20110602191101.GC31586@khazad-dum.debian.net>
Message-Id: <201106030719.EGD21835.LOJFHSFOFVOtMQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 3 Jun 2011 07:19:39 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 02062011 #5458400, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Thu, 02 Jun 2011, Tetsuo Handa wrote:
> > We need to widely announce that userland applications using branches based on
> > /proc/sys/kernel/osrelease need to be fixed.
> 
> A debug patch to disclose any userspace application that touches that file
> would be of some help, I suppose?

Testing with a 2.6.39 kernel built with a patch

--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
-VERSION = 2
-PATCHLEVEL = 6
-SUBLEVEL = 39
+VERSION = 3
+PATCHLEVEL = 0
+SUBLEVEL = 0
 EXTRAVERSION =
 NAME = Flesh-Eating Bats with Fangs

applied will be the best.

But a writable sysctl entry (or kernel boot command line option) that changes
the output of /proc/sys/kernel/osrelease may be of some help.
