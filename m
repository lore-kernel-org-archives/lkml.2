Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0INDD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 23:03:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49742
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753523Ab0INDDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 23:03:55 -0400
Date: Mon, 13 Sep 2010 20:04:13 -0700 (PDT)
Message-Id: <20100913.200413.116373901.davem@davemloft.net>
To: linux@rainbow-software.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] cx82310_eth: allow empty URBs
From: David Miller <davem@davemloft.net>
In-Reply-To: <201009111740.18843.linux@rainbow-software.org>
References: <201009111740.18843.linux@rainbow-software.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>
Date: Sat, 11 Sep 2010 17:40:16 +0200

> Empty received URBs are currently counted as errors but the device sends them
> sometimes as part of regular traffic - so remove this check.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Applied.
