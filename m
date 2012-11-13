Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab2KMV2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:28:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:61999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab2KMV2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:28:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,768,1352102400"; 
   d="scan'208";a="241671630"
From: "Luck, Tony" <tony.luck@intel.com>
To: James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-hexagon@vger.kernel.org" <linux-hexagon@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, Richard Kuo <rkuo@codeaurora.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>
Subject: RE: [PATCH 1/1] arch Kconfig: remove references to IRQ_PER_CPU
Thread-Topic: [PATCH 1/1] arch Kconfig: remove references to IRQ_PER_CPU
Thread-Index: AQHNwZaYI0r8PGS1HEq9XKPGYxEB6JfoR+uQ
Date: Tue, 13 Nov 2012 21:28:11 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D5F453@ORSMSX108.amr.corp.intel.com>
References: <1352807948-26920-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1352807948-26920-1-git-send-email-james.hogan@imgtec.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But IRQ_PER_CPU wasn't removed from any of the architecture Kconfig
> files where it was defined or selected. It's completely unused so remove
> the remaining references.

Acked-by: Tony Luck <tony.luck@intel.com>

[Hope someone picks up this whole patch ... otherwise I can take the ia64 hunk]
