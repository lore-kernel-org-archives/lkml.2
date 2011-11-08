Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab1KHRib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:38:31 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:37727 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab1KHRi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:38:28 -0500
Date: Tue, 08 Nov 2011 12:37:16 -0500 (EST)
Message-Id: <20111108.123716.1108093580193144770.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH] r8169: increase the delay parameter of
 pm_schedule_suspend
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111108090716.GA4885@electric-eye.fr.zoreil.com>
References: <1320734677-1372-1-git-send-email-hayeswang@realtek.com>
	<20111108090716.GA4885@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 08 Nov 2011 09:37:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Tue, 8 Nov 2011 10:07:16 +0100

> Hayes Wang <hayeswang@realtek.com> :
>> The link down would occur when reseting PHY. And it would take about 2 ~ 5 seconds
>> from link down to link up. If the delay of pm_schedule_suspend is not long enough,
>> the device would enter runtime_suspend before link up. After link up, the device
>> would wake up and reset PHY again. Then, you would find the driver keep in a loop
>> of runtime_suspend and rumtime_resume.
> 
> Acked-by: Francois Romieu <romieu@fr.zoreil.com>

Applied.
