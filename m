Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab0JULPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:15:38 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:57320 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078Ab0JULPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:15:37 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: tglx@linutronix.de
Subject: linux-next: User Mode Linux broken
Date: Thu, 21 Oct 2010 13:15:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: peterz@infradead.org, hpa@zytor.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211315.26679.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Your commit c5f7563 ("genirq: Provide compat handling for chip->enable()") 
breaks UML.
It does not start anymore.

When I apply this patch it works fine again.
http://userweb.kernel.org/~akpm/mmotm/broken-out/um-migrate-from-__do_irq-to-
generic_handle_irq.patch

Maybe your patch breaks all users of __do_IRQ()?

Thanks,
//richard
