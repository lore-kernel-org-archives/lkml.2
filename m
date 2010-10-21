Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0JUId3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:33:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33455
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307Ab0JUId2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:33:28 -0400
Date: Thu, 21 Oct 2010 01:33:50 -0700 (PDT)
Message-Id: <20101021.013350.112612844.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 4/7] sparc: convert to clocksource_register_hz/khz
From: David Miller <davem@davemloft.net>
In-Reply-To: <1287618253-13258-5-git-send-email-johnstul@us.ibm.com>
References: <1287618253-13258-3-git-send-email-johnstul@us.ibm.com>
	<1287618253-13258-4-git-send-email-johnstul@us.ibm.com>
	<1287618253-13258-5-git-send-email-johnstul@us.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>
Date: Wed, 20 Oct 2010 16:44:10 -0700

> This converts the sparc clocksources to use clocksource_register_hz/khz
> 
> This is untested, so any assistance in testing would be appreciated!
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Acked-by: David S. Miller <davem@davemloft.net>
