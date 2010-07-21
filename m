Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0GUVDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:03:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45150
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753719Ab0GUVDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:03:47 -0400
Date: Wed, 21 Jul 2010 14:04:04 -0700 (PDT)
Message-Id: <20100721.140404.168047053.davem@davemloft.net>
To: jkosina@suse.cz
Cc: segooon@gmail.com, kernel-janitors@vger.kernel.org, samuel@sortiz.org,
        shemminger@vyatta.com, joe@perches.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/19] drivers/net/irda: use for_each_pci_dev()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1007201732370.4741@pobox.suse.cz>
References: <1278173056-11779-1-git-send-email-segooon@gmail.com>
	<alpine.LNX.2.00.1007201732370.4741@pobox.suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Tue, 20 Jul 2010 17:33:01 +0200 (CEST)

> On Sat, 3 Jul 2010, Kulikov Vasiliy wrote:
> 
>> Use for_each_pci_dev() to simplify the code.
>> 
>> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
>> ---
...
> Doesn't seem to hit linux-next as of today. Dave, are you going to merge 
> it?

I'll apply this now, thanks.
