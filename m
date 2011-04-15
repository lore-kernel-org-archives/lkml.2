Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1DOWpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:45:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36285
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330Ab1DOWpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:45:32 -0400
Date: Fri, 15 Apr 2011 15:44:57 -0700 (PDT)
Message-Id: <20110415.154457.28809247.davem@davemloft.net>
To: sahne@0x90.at
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ipv6: ignore looped-back NA while dad is running
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110414070925.GA78446@0x90.at>
References: <20110414070925.GA78446@0x90.at>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <sahne@0x90.at>
Date: Thu, 14 Apr 2011 09:09:25 +0200

> [ipv6] Ignore looped-back NAs while in Duplicate Address Detection
> 
> If we send an unsolicited NA shortly after bringing up an
> IPv6 address, the duplicate address detection algorithm
> fails and the ip stays in tentative mode forever. 
> This is due a missing check if the NA is looped-back to us.
> 
> Signed-off-by: Daniel Walter <dwalter@barracuda.com>

Applied to net-next-2.6
