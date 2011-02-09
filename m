Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1BIJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:27:16 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:10627 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1BIJ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:27:15 -0500
X-IronPort-AV: E=Sophos;i="4.60,446,1291611600"; 
   d="scan'208";a="134985866"
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110208162045.GB4606@dumpdata.com>
References: <20110205200108.921707839@linutronix.de>
	 <4D50641B.2090006@goop.org>
	 <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>
	 <4D506AE6.6080900@goop.org>
	 <1297173811.9388.95.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>
	 <1297177506.9388.135.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1102081619410.31804@localhost6.localdomain6>
	 <20110208162045.GB4606@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 9 Feb 2011 09:27:11 +0000
Message-ID: <1297243631.9388.258.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 16:20 +0000, Konrad Rzeszutek Wilk wrote:

> This is what I've in the stable/irq.rework [...] Please tell me if I messed up.

I tested v2.6.38-rc4:
+= git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip irq/for-xen
+= git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen stable/irq.rework

and all seems fine.

Thanks,
Ian.

