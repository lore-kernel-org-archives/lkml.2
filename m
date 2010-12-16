Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab0LPUYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:24:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51237
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910Ab0LPUYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:24:12 -0500
Date: Thu, 16 Dec 2010 12:24:40 -0800 (PST)
Message-Id: <20101216.122440.115943226.davem@davemloft.net>
To: dhillf@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix bug in Ethernet Channel Bonding Driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTiksuf0ZDWyjH6ec9rSRoG+5ZdakA-Tha9MXLvy+@mail.gmail.com>
References: <AANLkTiksuf0ZDWyjH6ec9rSRoG+5ZdakA-Tha9MXLvy+@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>
Date: Sat, 11 Dec 2010 12:54:11 +0800

> The returned slave is incorrect, if the net device under check is not
> charged yet by the master.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Applied, thank you.
