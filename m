Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab0HQBy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 21:54:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:10129 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab0HQByz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 21:54:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,379,1278313200"; 
   d="scan'208";a="597199282"
Date: Tue, 17 Aug 2010 09:37:34 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>
Subject: One question about 8250 UART driver
Message-ID: <20100817013734.GA28407@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We have a PCI based UART controller that is compatible with the existing
8250 serial driver in most aspects. However, one exception is that our
UART controller can take advantage of the onboard DMA contoller to
achieve higher throughput. Could you please share your insights about
what is the proper way to add such DMA support into existing 8250 driver?

Thanks
-Yong

