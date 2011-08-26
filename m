Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1HZH0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 03:26:50 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:42541 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751506Ab1HZH0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 03:26:48 -0400
Message-ID: <885a6d6210a7d4c56601380f146e7ba9.squirrel@xenotime.net>
In-Reply-To: <20110825163515.0ed2cf354f61a3e9c53564b2@canb.auug.org.au>
References: <20110825163515.0ed2cf354f61a3e9c53564b2@canb.auug.org.au>
Date: Fri, 26 Aug 2011 00:26:48 -0700
Subject: Re: linux-next: Tree for Aug 25
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org
Cc: linux-next@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:program running on server}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, August 24, 2011 11:35 pm, Stephen Rothwell wrote:
> Hi all,
>
> The powerpc allyesconfig build still fails today.


CONFIG_FCOE is not enabled:

drivers/scsi/bnx2fc/bnx2fc_fcoe.c: In function 'bnx2fc_net_config':
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:765: error: 'NETDEV_FCOE_WWNN'
undeclared (first use in this function)
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:771: error: 'NETDEV_FCOE_WWPN'
undeclared (first use in this function)


Maybe this driver should select FCOE?

~Randy

