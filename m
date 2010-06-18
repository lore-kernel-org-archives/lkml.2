Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317Ab0FRQ7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 12:59:33 -0400
Received: from www.tglx.de ([62.245.132.106]:33290 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758222Ab0FRQ7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 12:59:32 -0400
From: John Ogness <john.ogness@linutronix.de>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] mtd: mxc_nand fixups
Date: Fri, 18 Jun 2010 18:58:59 +0200
Message-ID: <80ljacb7l8.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following 5 patches fix several issues with the MXC NFC
driver. These changes were tested using an i.MX35 with a 16-bit flash
chip (2K pages, 64 pages per eraseblock).

Many of the changes are sitting behind a nfc_is_v21() check because I do
not know if the older NAND controllers are the same.

John Ogness
