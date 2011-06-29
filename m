Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1F2LNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:13:35 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:28582 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab1F2LNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:13:32 -0400
Date: Wed, 29 Jun 2011 13:13:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] i2c fixes for 3.0
Message-ID: <20110629131322.20bf7c5f@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem fixes for Linux 3.0 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 drivers/i2c/busses/i2c-taos-evm.c |    8 ++++----
 drivers/i2c/muxes/pca954x.c       |    7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

---------------

Jean Delvare (1):
      i2c-taos-evm: Fix log messages

Petri Gynther (1):
      i2c/pca954x: Initialize the mux to disconnected state

Thanks,
-- 
Jean Delvare
