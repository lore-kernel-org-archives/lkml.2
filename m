Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab0I2Fws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:52:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56054 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0I2Fwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:52:47 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, edgar.iglesias@gmail.com, duyl@xilinx.com,
        linnj@xilinx.com, grant.likely@secretlab.ca,
        microblaze-uclinux@itee.uq.edu.au
Subject: Microblaze little-endian port + driver changes
Date: Wed, 29 Sep 2010 15:52:11 +1000
Message-Id: <1285739538-29058-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

here is the first bunch of patches which is necessary to apply 
to get microblaze little-endian AXI version work.

All patches are placed in microblaze-next branch and they are also
merged to linux-next branch.

Grant: I would like to ask you if you can please take a look
at little-endian driver changes. 

Thanks for your review,
Michal


