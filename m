Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab1BWVZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:25:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42745
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753150Ab1BWVZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:25:53 -0500
Date: Wed, 23 Feb 2011 13:26:29 -0800 (PST)
Message-Id: <20110223.132629.104051788.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 4/6] sparc: convert to clocksource_register_hz/khz
From: David Miller <davem@davemloft.net>
In-Reply-To: <1297838092-22989-5-git-send-email-johnstul@us.ibm.com>
References: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
	<1297838092-22989-5-git-send-email-johnstul@us.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>
Date: Tue, 15 Feb 2011 22:34:50 -0800

> This converts the sparc clocksources to use clocksource_register_hz/khz
> 
> This is untested, so any assistance in testing would be appreciated!
> 
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Applied, but please CC: sparclinux@vger.kernel.org for sparc patches.
