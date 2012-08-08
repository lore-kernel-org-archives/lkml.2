Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab2HHXEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:04:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47496 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261Ab2HHXE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:04:29 -0400
Date: Wed, 08 Aug 2012 16:04:28 -0700 (PDT)
Message-Id: <20120808.160428.2244694881256062176.davem@davemloft.net>
To: ordex@autistici.org
Cc: jj@chaosbits.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, siwu@hrz.tu-chemnitz.de,
        lindner_marek@yahoo.de
Subject: Re: [PATCH] batman-adv: Fix mem leak in the
 batadv_tt_local_event() function
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120807185036.GG3891@ritirata.org>
References: <alpine.LNX.2.00.1208072030500.3227@swampdragon.chaosbits.net>
	<20120807185036.GG3891@ritirata.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonio Quartulli <ordex@autistici.org>
Date: Tue, 7 Aug 2012 20:50:36 +0200

> On Tue, Aug 07, 2012 at 08:32:34PM +0200, Jesper Juhl wrote:
>> Memory is allocated for 'tt_change_node' with kmalloc().
>> 'tt_change_node' may go out of scope really being used for anything
>> (except have a few members initialized) if we hit the 'del:' label.
>> This patch makes sure we free the memory in that case.
>> 
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Acked-by: Antonio Quartulli <ordex@autistici.org>

Applied, thanks.
