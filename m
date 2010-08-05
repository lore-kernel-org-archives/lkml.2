Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab0HEE2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 00:28:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57201 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0HEE2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 00:28:53 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, will_schmidt@vnet.ibm.com, tglx@linutronix.de,
        nfont@austin.ibm.com, rcj@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, dvhltc@us.ibm.com
Subject: [PATCH 0/4] powerpc: cpu offline/online fixes for CONFIG_PREEMPT
Date: Wed,  4 Aug 2010 21:28:32 -0700
Message-Id: <1280982515-18231-1-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series addresses several issues detected during intense CPU
offline/online testing on the mainline kernel with CONFIG_PREEMPT=y. These
patches require the following patch from Brian King:

http://patchwork.ozlabs.org/patch/59645/

Tested against linux-2.6.git master with and without CONFIG_DEBUG_PREEMPT.

