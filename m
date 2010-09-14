Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0INDDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 23:03:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49738
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab0INDDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 23:03:48 -0400
Date: Mon, 13 Sep 2010 20:04:07 -0700 (PDT)
Message-Id: <20100913.200407.242136382.davem@davemloft.net>
To: linux@rainbow-software.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] cx82310_eth: check usb_string() return
 value for error
From: David Miller <davem@davemloft.net>
In-Reply-To: <201009111740.00243.linux@rainbow-software.org>
References: <201009111740.00243.linux@rainbow-software.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>
Date: Sat, 11 Sep 2010 17:39:57 +0200

> Fix that usb_string() return value is not checked for error (negative value).
> Also change the ignore message a bit and lower its level to info.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Applied.
