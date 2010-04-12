Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0DLGoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:44:55 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:47730 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0DLGoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:44:54 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: benh@kernel.crashing.org
Subject: 
Date: Mon, 12 Apr 2010 16:43:14 +1000
Message-Id: <1271054596-26561-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add the required mappings to use perf probe on PowerPC.

Functionality wise it requires patch 359e4284a3f37aba7fd06d993863de2509d86f54
from the powerpc-next tree to provide the HAVE_REGS_AND_STACK_ACCESS_API
required for CONFIG_KPROBE_EVENT. The code will still compile cleanly without
it and will fail gracefully at runtime on the missing CONFIG_KPROBE_EVENT
support as before.

Part 1 of the patch series moves the arch dependent x86 32 and 64 bit DWARF
register number mappings out into a separate arch directory and adds the
necessary Makefile foo to use it.

Part 2 of the patch series adds the PowerPC mappings.

Thanks,
-Ian

