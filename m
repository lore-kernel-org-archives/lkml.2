Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab1AZMNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:13:30 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:62204 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab1AZMN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:13:28 -0500
Subject: [GIT PULL] AVR32 fixes for 2.6.38
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: AVR32 Linux Kernel <kernel@avr32linux.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 26 Jan 2011 13:13:08 +0100
Message-ID: <1296043988.3065.18.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2011 12:13:09.0426 (UTC) FILETIME=[65463920:01CBBD52]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/avr32-2.6.git for-linus

to receive the following fixes for 2.6.38

Hans-Christian Egtvedt (1):
      avr32: add missing include causing undefined pgtable_page_* references

 arch/avr32/include/asm/pgalloc.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

-- 
Hans-Christian Egtvedt

