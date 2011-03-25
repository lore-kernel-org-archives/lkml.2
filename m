Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab1CYNc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:32:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:33063 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751173Ab1CYNc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:32:56 -0400
Message-Id: <20110325133039.521553268@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:32:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [patch 0/2] blackfin: Final irq cleanup
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

this is the final cleanup and name space conversion, so that we can
remove the deprecated code in the core.

It would be nice to get this Linus wards for .39

Thanks,

	tglx



