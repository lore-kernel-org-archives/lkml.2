Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab0IJE4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 00:56:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58568
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476Ab0IJE4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 00:56:06 -0400
Date: Thu, 09 Sep 2010 21:56:24 -0700 (PDT)
Message-Id: <20100909.215624.45886987.davem@davemloft.net>
To: nikitasangelinas@gmail.com
Cc: eilong@broadcom.com, dmitry@broadcom.com, yanivr@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] drivers/net/bnx2x: use ARRAY_SIZE macro in
 bnx2x_main.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283980837-5025-1-git-send-email-nikitasangelinas@gmail.com>
References: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
	<1283980837-5025-1-git-send-email-nikitasangelinas@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikitas Angelinas <nikitasangelinas@gmail.com>
Date: Wed,  8 Sep 2010 22:20:37 +0100

> Replace sizeof(bnx2x_parity_mask)/(sizeof(bnx2x_parity_mask[0]) with
> ARRAY_SIZE(bnx2x_parity_mask) in drivers/net/bnx2x/bnx2x_main.c
> 
> Signed-off-by: Nikitas Angelinas <nikitasangelinas@gmail.com>

Applied, thank you.
