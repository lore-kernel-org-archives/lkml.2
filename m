Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0FXPki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:40:38 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:37093 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab0FXPkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:40:35 -0400
Message-ID: <4C237C70.70409@pardus.org.tr>
Date: Thu, 24 Jun 2010 18:40:32 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] Suspend regression in v2.6.31 with Lenovo 3000 v200
References: <Pine.LNX.4.44L0.1006241004430.1654-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006241004430.1654-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:

> 
> The content of the power/wakeup file depends on two values: the 
> can_wakeup flag and the should_wakeup flag.  If can_wakeup is false 
> then the file will be empty; otherwise it will contain "disabled" or 
> "enabled" according to the value of should_wakeup.
> 
> Now, device_init_wakeup() sets both flags whereas 
> device_set_wakeup_capable() affects only the can_wakeup flag.  After 
> this change is made there should be nothing in the kernel that turns on 
> the should_wakeup flag, and consequently remote wakeup should remain 
> disabled.
> 
> You can check this by grepping for occurrences of "should_wakeup" or 
> "dev_set_wakeup_enable" (which affects the should_wakeup flag).
> 
> Alan Stern
> 

Okay the patch fixed the issue for the users. Thanks again for all your
helps, 

Regards,
Ozan Caglayan
