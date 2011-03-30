Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1C3CMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:12:12 -0400
Received: from lo.gmane.org ([80.91.229.12]:34756 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab1C3CMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:12:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: jmheo <jongman.heo@gmail.com>
Subject: compile error with 2.6.39-rc1 (in =?utf-8?b?YXJjaC94ODYva2VybmVsL2FwYl90aW1lci5jKQ==?=
Date: Wed, 30 Mar 2011 02:11:57 +0000 (UTC)
Message-ID: <loom.20110330T040947-18@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 210.94.41.89 (Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; MS-RTC LM 8; .NET4.0C; .NET4.0E))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I got following compile error with 2.6.39-rc1.

arch/x86/kernel/apb_timer.c: In function ??apbt_setup_irq??:
arch/x86/kernel/apb_timer.c:319:2: error: implicit declaration of function ??
__set_irq_handler??
make[2]: *** [arch/x86/kernel/apb_timer.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2
make: *** Waiting for unfinished jobs....


I have CONFIG_APB_TIMER & CONFIG_SMP in my .config.

