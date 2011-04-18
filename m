Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab1DRG3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 02:29:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34880
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706Ab1DRG3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 02:29:45 -0400
Date: Sun, 17 Apr 2011 23:29:10 -0700 (PDT)
Message-Id: <20110417.232910.245382216.davem@davemloft.net>
To: decot@google.com
Cc: eilong@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2x: cosmetics: Using ethtool_cmd_speed() API
From: David Miller <davem@davemloft.net>
In-Reply-To: <1302833494-22266-1-git-send-email-decot@google.com>
References: <1302833494-22266-1-git-send-email-decot@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@google.com>
Date: Thu, 14 Apr 2011 19:11:34 -0700

> This updates bnx2x to use the ethtool_cmd_speed() family of functions
> (see b11f8d8c in 2.6.27-rc3 aka. "ethtool: Expand ethtool_cmd.speed to
> 32 bits") to get and set the link speed via ethtool. This allows to
> avoid manually accessing ethtool_cmd's speed_hi field.
> 
> Signed-off-by: David Decotigny <decot@google.com>

Applied, thank you.
