Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab2INCCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 22:02:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33690 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab2INCCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 22:02:18 -0400
MIME-Version: 1.0
Date: Fri, 14 Sep 2012 10:02:16 +0800
Message-ID: <CACVXFVOV9GfWxmbxDhKCOd0UWRPoORj5=dSiKdQrwnkf3cdNJw@mail.gmail.com>
Subject: Question on irq autoprobe
From: Ming Lei <tom.leiming@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see the below comments on probe_irq_off:

     *  BUGS: When used in a module (which arguably shouldn't happen)
     *  nothing prevents two IRQ probe callers from overlapping. The
     *  results of this are non-optimal.
     */

But from the code of probe_irq_on and probe_irq_off, the mutex of
probing_active is held during the whole irq probe procedure, so
I don't understand why the above said that 'nothing prevents two
IRQ probe callers from overlapping", and why isn't the mutex of
probing_active enough to avoid the overlapping?


Thanks,
-- 
Ming Lei
