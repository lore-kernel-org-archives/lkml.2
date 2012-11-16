Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab2KPFqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 00:46:39 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:32927 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab2KPFqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 00:46:38 -0500
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org, magnus.damm@gmail.com,
        horms@verge.net.au
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH 0/4] UIO platform device fixes
Date: Fri, 16 Nov 2012 14:46:08 +0900
Message-Id: <1353044772-18803-1-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few fixes for the uio_dmem_genirq driver which allows for
dynamic allocation/deallocation of UIO memory resources via the
DMA-mapping API.


Damian Hobson-Garcia (4):
  drivers: uio_dmem_genirq: Don't mix address spaces for dynamic region
    vaddr
  drivers: uio_dmem_genirq: Don't use DMA_ERROR_CODE to indicate
    unmapped regions
  drivers: uio_dmem_genirq: Allow partial success when opening device
  drivers: uio: Only allocate new private data when probing device tree
    node

 Documentation/DocBook/uio-howto.tmpl |    2 +-
 drivers/uio/uio_dmem_genirq.c        |   25 +++++++++++++++----------
 drivers/uio/uio_pdrv_genirq.c        |    2 +-
 3 files changed, 17 insertions(+), 12 deletions(-)

-- 
1.7.5.4

