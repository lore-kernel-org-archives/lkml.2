Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0HJKFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 06:05:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:44019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab0HJKE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 06:04:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,347,1278313200"; 
   d="scan'208";a="826267224"
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/2] Battery fixes
To: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Aug 2010 10:27:43 +0100
Message-ID: <20100810092700.1814.11982.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox (1):
      intel mid battery: Fix battery scaling

Arjan van de Ven (1):
      Fix the argument order to intel_scu_ipc_command in the battery driver


 drivers/power/intel_mid_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
	"CMS is like a porcupine in a balloon factory"
					--Alan Altmark


