Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab0JYTPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:15:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40803
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759415Ab0JYTP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:15:27 -0400
Date: Mon, 25 Oct 2010 12:15:50 -0700 (PDT)
Message-Id: <20101025.121550.115922916.davem@davemloft.net>
To: Joshua.Hoke@sixnet.com
Cc: nicolas.ferre@atmel.com, jpirko@redhat.com, peter.korsgaard@barco.com,
        eric.dumazet@gmail.com, haavard.skinnemoen@atmel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] macb: Don't re-enable interrupts while in polling mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <C8F551D39A7C724E987CF8DD11D3178304D7CC86@svr3.sixnetio.com>
References: <C8F551D39A7C724E987CF8DD11D3178304D02F88@svr3.sixnetio.com>
	<20101024.152306.48512783.davem@davemloft.net>
	<C8F551D39A7C724E987CF8DD11D3178304D7CC86@svr3.sixnetio.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Joshua Hoke" <Joshua.Hoke@sixnet.com>
Date: Mon, 25 Oct 2010 07:44:22 -0400

> [PATCH] macb: Don't re-enable interrupts while in polling mode

Applied.
