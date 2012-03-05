Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab2CERer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:34:47 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:60678 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab2CERep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:34:45 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/5] staging: zsmalloc: remove SPARSEMEM dependency
Date: Mon,  5 Mar 2012 11:33:19 -0600
Message-Id: <1330968804-8098-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030517-3352-0000-0000-0000031D3810
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes the dependency zsmalloc has on SPARSEMEM;
more specifically the assumption that MAX_PHYSMEM_BITS is defined.

Based on greg/staging-next.

Seth Jennings (5):
  staging: zsmalloc: move object/handle masking defines
  staging: zsmalloc: add ZS_MAX_PAGES_PER_ZSPAGE
  staging: zsmalloc: calculate MAX_PHYSMEM_BITS if not defined
  staging: zsmalloc: change ZS_MIN_ALLOC_SIZE
  staging: zsmalloc: remove SPARSEMEM dep from Kconfig

 drivers/staging/zsmalloc/Kconfig         |    2 +-
 drivers/staging/zsmalloc/zsmalloc-main.c |   14 +---------
 drivers/staging/zsmalloc/zsmalloc_int.h  |   43 +++++++++++++++++++++++++-----
 3 files changed, 38 insertions(+), 21 deletions(-)

-- 
1.7.5.4

