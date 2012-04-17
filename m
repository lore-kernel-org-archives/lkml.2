Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2DQPLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:11:48 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:52901 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2DQPLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:11:47 -0400
X-IronPort-AV: E=Sophos;i="4.75,436,1330905600"; 
   d="scan'208";a="11982860"
Message-ID: <1334675504.23948.99.camel@zakaz.uk.xensource.com>
Subject: In tree firmware not kept up to date
From: Ian Campbell <Ian.Campbell@citrix.com>
To: <netdev@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
CC: Ian Jackson <Ian.Jackson@eu.citrix.com>, Michael Chan <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>
Date: Tue, 17 Apr 2012 16:11:44 +0100
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

What is the current policy wrt keeping the in-tree firmware updated
alongside the drivers?

I use CONFIG_FIRMWARE_IN_KERNEL but a couple of times[0] recently this
has failed me because the in-tree bnx2 driver requires
bnx2/bnx2-mips-09-6.2.1b.fw but the tree contains
firmware/bnx2/bnx2-mips-09-6.2.1a.fw.ihex and not 6.2.1b.

Is it a bug that bnx2 was updated without adding the new firmware or is
a bug that the obsolete firmware is still sitting in the tree?

Ian.

[0] It's possible the same thing and I've just tripped over it more than
once now.

