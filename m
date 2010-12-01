Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0LAQsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:48:21 -0500
Received: from re01.intra2net.com ([82.165.28.202]:35297 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0LAQsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:48:19 -0500
X-Greylist: delayed 1138 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2010 11:48:19 EST
From: "Gerd v. Egidy" <lists@egidy.de>
To: linux-kernel@vger.kernel.org
Subject: how to read block device size from sysfs?
Date: Wed, 1 Dec 2010 17:29:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-61.fc13.x86_64; KDE/4.5.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012011729.18661.lists@egidy.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to read the size of a block device in bytes from sysfs.

There are /sys/block/<device>/size and 
/sys/block/<device>/<device><partition>/size.

But these values are reported in sectors, not in bytes. As discs with 4K 
sectors are on the horizon now, I don't want to make wrong assumptions on the 
sector size.

So what is the correct sector size for /sys/block/<device>/size?

/sys/block/<device>/queue/logical_block_size,
/sys/block/<device>/queue/physical_block_size or something else?

While searching for an answer I've stumbled across some reports about drives 
lying about their sector sizes to "improve" compatibility. Is there some best 
practice to still get the correct size in bytes?

Kind regards,

Gerd

-- 
Address (better: trap) for people I really don't want to get mail from:
jonas@cactusamerica.com
