Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab1DVAAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:00:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33283
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755419Ab1DVAAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:00:15 -0400
Date: Thu, 21 Apr 2011 16:59:41 -0700 (PDT)
Message-Id: <20110421.165941.260095636.davem@davemloft.net>
To: gizero@gmail.com
Cc: pantelis.antoniou@gmail.com, vbordug@ru.mvista.com,
        scottwood@freescale.com, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] powerpc: Fix multicast problem in fs_enet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1303388481-17993-1-git-send-email-gizero@gmail.com>
References: <1303388481-17993-1-git-send-email-gizero@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Galbusera <gizero@gmail.com>
Date: Thu, 21 Apr 2011 14:21:21 +0200

> mac-fec.c was setting individual UDP address registers instead of multicast
> group address registers when joining a multicast group.
> This prevented from correctly receiving UDP multicast packets.
> According to datasheet, replaced hash_table_high and hash_table_low
> with grp_hash_table_high and grp_hash_table_low respectively.
> Also renamed hash_table_* with grp_hash_table_* in struct fec declaration
> for 8xx: these registers are used only for multicast there.
> 
> Tested on a MPC5121 based board.
> Build tested also against mpc866_ads_defconfig.
> 
> Signed-off-by: Andrea Galbusera <gizero@gmail.com>

Applied, thanks.
