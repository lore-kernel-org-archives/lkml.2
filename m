Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab1HXKLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 06:11:34 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:58747 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1HXKLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 06:11:32 -0400
Message-ID: <4E54CE15.1020504@atmel.com>
Date: Wed, 24 Aug 2011 12:10:29 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.20) Gecko/20110804 Lightning/1.0b2 Thunderbird/3.1.12
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Remy Bohmer <linux@bohmer.net>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91: fixes for 3.1
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Can you please pull this "fixes" patch since commit fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c:

  Linux 3.1-rc3 (2011-08-22 11:42:53 -0700)

It is available in the git repository at:
  git://github.com/at91linux/linux-2.6-at91.git at91-fixes

Jean-Christophe PLAGNIOL-VILLARD (1):
      at91: at91sam9261.c: fix typo in t2_clk alias for atmel_tcb.0

 arch/arm/mach-at91/at91sam9261.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

It is a single patch but I prefer to send you a 
pull request as it may integrate better with your
flow...

Thanks a lot, bye,
-- 
Nicolas Ferre

