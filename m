Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab2KSRi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:38:27 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:14709 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2KSRi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:38:26 -0500
Message-ID: <50AA6E90.5080006@atmel.com>
Date: Mon, 19 Nov 2012 18:38:24 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: tiny cleanup for 3.8
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

A very little cleanup single patch for AT91.

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-for-next-cleanup

for you to fetch changes up to f7c9f47239e9bc2fdf30f51cf46249aeb79980d3:

  ARM: at91/atmel-mci: remove unused setup_dma_addr() macro (2012-11-16 11:52:36 +0100)

----------------------------------------------------------------
Removing unneeded macro.

----------------------------------------------------------------
Nicolas Ferre (1):
      ARM: at91/atmel-mci: remove unused setup_dma_addr() macro

 arch/arm/mach-at91/include/mach/atmel-mci.h | 7 -------
 1 file changed, 7 deletions(-)

Thanks, bye,
-- 
Nicolas Ferre
