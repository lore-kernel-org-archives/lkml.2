Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2C1Cwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 22:52:36 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53513 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab2C1Cwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 22:52:32 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q2S2qP8e009362
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1332834834-5185-1-git-send-email-hayeswang@realtek.com> <20120327225407.GB22177@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 1/5] r8169: modify pll power function
Date: Wed, 28 Mar 2012 10:52:24 +0800
Message-ID: <B353B7C4530143B29686566C4F883487@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac0MbOOtjjhLGZseSBWWRIKsJyTjCwAHcilA
In-Reply-To: <20120327225407.GB22177@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Wednesday, March 28, 2012 6:54 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next 1/5] r8169: modify pll power function
> 
> Hayes Wang <hayeswang@realtek.com> :
> > Adjust r810x_pll_power_down, r810x_pll_power_up, and 
> r8168_pll_power_up.
> > Always power up device during rtl_open.
> > For r810x, turn off more power when the WOL is disabled.
> 
> Would the "Always power up" part qualify as a "fix something" change ?
> 

I don't see any issue about this yet. It seems to be reasonable to make suer the
device would work when the open is called no matter the power is turned off
before or not. 

Best Regards,
Hayes

