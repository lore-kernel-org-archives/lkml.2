Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1CGOwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 09:52:11 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:28958 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab1CGOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 09:52:09 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Mar 2011 09:52:08 EST
X-IronPort-AV: E=Sophos;i="4.62,277,1297036800"; 
   d="scan'208";a="4651970"
Subject: tip tree allows nr_irqs to increase dynamically?
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 7 Mar 2011 14:42:19 +0000
Message-ID: <1299508939.17339.376.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

It looks like tip.git irq/core contains patches to allow nr_irqs to
expand dynamically. Are these targeted at 2.6.39 or something later?

I'm working on some cleanups to Xen's irq handling and they will
require/interact with this new behaviour, is there a suitable commit
which I could consider for pulling into my tree to build upon?

Thanks,
Ian.

