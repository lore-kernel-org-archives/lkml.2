Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0CWUJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:09:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50274
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613Ab0CWUJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:09:19 -0400
Date: Tue, 23 Mar 2010 13:09:42 -0700 (PDT)
Message-Id: <20100323.130942.09762502.davem@davemloft.net>
To: JRottmann@LiPPERTEmbedded.de
Cc: Tristram.Ha@micrel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ksz884x: fix return value of netdev_set_eeprom
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BA8CEF6.2010707@LiPPERTEmbedded.de>
References: <4BA8CEF6.2010707@LiPPERTEmbedded.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Date: Tue, 23 Mar 2010 15:23:50 +0100

> ksz884x: fix return value of netdev_set_eeprom
> 
> netdev_set_eeprom() confused ethtool by just returning 1 on error
> instead of a proper -EINVAL.
> 
> Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>

Applied, thank you.
