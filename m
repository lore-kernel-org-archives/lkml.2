Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1AJCOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 21:14:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47495
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290Ab1AJCOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 21:14:48 -0500
Date: Sun, 09 Jan 2011 18:15:19 -0800 (PST)
Message-Id: <20110109.181519.45898043.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: torvalds@linux-foundation.org, benh@debian.org, hayeswang@realtek.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110108121726.GA2216@electric-eye.fr.zoreil.com>
References: <AANLkTinANp+Jp8TPKzii6iZLUFpMyrXhmxYr42nZrXQU@mail.gmail.com>
	<20110108000901.GA2133@electric-eye.fr.zoreil.com>
	<20110108121726.GA2216@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Sat, 8 Jan 2011 13:17:26 +0100

> r8169: delay phy init until device opens.
> 
> It workarounds the 60s firmware load failure timeout for the
> non-modular case.
> 
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

Applied, thanks.
