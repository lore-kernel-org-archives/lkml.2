Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab0LTSil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:38:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41104
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932563Ab0LTSik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:38:40 -0500
Date: Mon, 20 Dec 2010 10:39:09 -0800 (PST)
Message-Id: <20101220.103909.112598083.davem@davemloft.net>
To: andi@lisas.de
Cc: arnd@arndb.de, dhollis@davehollis.com, pchang23@sbcglobal.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add USB PID for new MOSCHIP USB ethernet
 controller MCS7832 variant
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101219154257.GA29086@rhlx01.hs-esslingen.de>
References: <20101130200737.GA5185@rhlx01.hs-esslingen.de>
	<20101219154257.GA29086@rhlx01.hs-esslingen.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Mohr <andi@lisas.de>
Date: Sun, 19 Dec 2010 16:42:57 +0100

> Due to active notification of the new MCS7832 version by the manufacturer
> (Mr. Milton; thanks!) -- quote: "functionality same as MCS7830",
> I'm now submitting this patch (on -rc6), intended for networking.git and -stable.
> 
> - add MCS7832 USB PID to be able to support this new device variant, too
> - add related descriptions
> 
> Signed-off-by: Andreas Mohr <andi@lisas.de>

Applied.
