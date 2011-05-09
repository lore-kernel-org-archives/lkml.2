Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab1EITw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:52:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60563
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366Ab1EITw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:52:27 -0400
Date: Mon, 09 May 2011 12:51:54 -0700 (PDT)
Message-Id: <20110509.125154.35047036.davem@davemloft.net>
To: joe@perches.com
Cc: grundler@parisc-linux.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] tulip: Convert printks to netdev_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <c9b94faed52877c10be832da384d9a327c36193a.1304970062.git.joe@perches.com>
References: <cover.1304970062.git.joe@perches.com>
	<c9b94faed52877c10be832da384d9a327c36193a.1304970062.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon,  9 May 2011 12:45:21 -0700

> Use the current more descriptive logging styles.
> 
> Add pr_fmt and remove PFX where appropriate.
> Use netif_<level>, netdev_<level>
> Indent a few blocks in xircom_cb where appropriate.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
