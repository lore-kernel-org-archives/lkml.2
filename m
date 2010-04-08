Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0DHExs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:53:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40880
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004Ab0DHExq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:53:46 -0400
Date: Wed, 07 Apr 2010 21:53:49 -0700 (PDT)
Message-Id: <20100407.215349.39367977.davem@davemloft.net>
To: peter.korsgaard@barco.com
Cc: haavard.skinnemoen@atmel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] macb: allow reception of large (>1518 bytes) frames
From: David Miller <davem@davemloft.net>
In-Reply-To: <1270652389-5364-1-git-send-email-peter.korsgaard@barco.com>
References: <1270652389-5364-1-git-send-email-peter.korsgaard@barco.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Korsgaard <peter.korsgaard@barco.com>
Date: Wed,  7 Apr 2010 16:59:49 +0200

> Enable BIG bit in the network configuration register, so the MAC doesn't
> reject big frames (E.G. when vlans are used).
> 
> Signed-off-by: Peter Korsgaard <peter.korsgaard@barco.com>

Applied to net-next-2.6, thanks.
