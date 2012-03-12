Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab2CLRNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:13:07 -0400
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:57329 "EHLO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab2CLRND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:13:03 -0400
From: Martyn Welch <martyn.welch@ge.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH V2 0/2] powerpc: Add support for GE IMP3A
Date: Mon, 12 Mar 2012 17:12:56 +0000
Message-Id: <1331572380-1064-1-git-send-email-martyn.welch@ge.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for the GE IMP3A. This board (based on a Freescale
P2020) uses some support for FPGA logic common with the PPC9A and other 86xx
based boards, so this support has been moved out of the 86xx directory. A
config option (GE_FPGA) has been added to reduce churn on dependant drivers
(such as the watchdog timer) when further boards are added.

