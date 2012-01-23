Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2AWVy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:54:57 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:24270 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2AWVyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:54:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: dave@linux.vnet.ibm.com, cascardo@holoscopio.com,
        sjenning@linux.vnet.ibm.com
Subject: [PATCH] zcache fix for 3.3-rc1.
Date: Mon, 23 Jan 2012 16:52:19 -0500
Message-Id: <1327355540-30681-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F1DD728.005E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

I posted this patch some time ago  [https://lkml.org/lkml/2012/1/13/253]
but I am not seeing it in you tree.

Was wondering if you could stick this patch in your tree? It fixes
a performance regressions which is quite noticable in small memory systems
where a 'swapoff' ends up taking more than it should.

Thanks!

Dan Magenheimer (1):
      zcache: Set SWIZ_BITS to 8 to reduce tmem bucket lock contention.

 drivers/staging/zcache/zcache-main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

