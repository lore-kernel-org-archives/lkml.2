Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1AFURJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:17:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35199
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583Ab1AFURI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:17:08 -0500
Date: Thu, 06 Jan 2011 12:17:39 -0800 (PST)
Message-Id: <20110106.121739.258115710.davem@davemloft.net>
To: pavel@ucw.cz
Cc: stefani@seibold.net, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] UDPCP Communication Protocol
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110106201100.GA3582@ucw.cz>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
	<20110106201100.GA3582@ucw.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>
Date: Thu, 6 Jan 2011 21:11:00 +0100

> Hi!
> 
>> UDPCP is a communication protocol specified by the Open Base Station
>> Architecture Initiative Special Interest Group (OBSAI SIG). The
>> protocol is based on UDP and is designed to meet the needs of "Mobile
>> Communcation Base Station" internal communications. It is widely used by
>> the major networks infrastructure supplier.
> 
> Why does it need to be in kernel?

To avoid a 40% performance hit which he explained in these threads.
