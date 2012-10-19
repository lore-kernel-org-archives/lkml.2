Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab2JSRQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:16:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:3010 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab2JSRQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:16:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,613,1344236400"; 
   d="scan'208";a="229790139"
From: "Luck, Tony" <tony.luck@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linus-arch@vger.kernel.org" <linus-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Jonas Bonn <jonas@southpole.se>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: RE: new execve/kernel_thread design
Thread-Topic: new execve/kernel_thread design
Thread-Index: AQHNq+6Tvf4Kwo9jKkmvR03nZz0CIJfBP/+A//+ia5A=
Date: Fri, 19 Oct 2012 17:16:50 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D57A82@ORSMSX108.amr.corp.intel.com>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <20121019154901.GK2616@ZenIV.linux.org.uk>
In-Reply-To: <20121019154901.GK2616@ZenIV.linux.org.uk>
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

> Surprisingly enough, ia64 one seems to work on actual hardware; I have sent
> Tony an incremental patch cleaning copy_thread() up, waiting for results of
> testing that on SMP box.

Tiny bit faster than plain 3.7-rc1. lmbench3 reports fork+execve test at between
558 to 567 usec with the new code, compared with 562-572 usec with the old.

-Tony
