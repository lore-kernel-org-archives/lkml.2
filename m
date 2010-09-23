Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0IWMPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:15:09 -0400
Received: from lo.gmane.org ([80.91.229.12]:41044 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab0IWMPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:15:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: AlexMach <alexvm12e@mail.ru>
Subject: Interrupt processing at Sparc64
Date: Thu, 23 Sep 2010 12:08:00 +0000 (UTC)
Message-ID: <loom.20100923T133417-126@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 213.182.162.106 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.17) Gecko/2010011009 Mandriva/1.9.0.17-0.1mdv2009.1 (2009.1) Firefox/3.0.17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As I understend from Linux source code is need to add ttable.S to kernel for
interrupt processing from devices (for calling sun4v_dev_mondo() and
handler_irq()) but the file isn't including to Makefile at /arch/Sparc/Kernel.
So why the file isn't including in makefile and how interrupts processing works?

Thanks,
Alex.

