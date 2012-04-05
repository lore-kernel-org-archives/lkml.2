Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2DEIlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:41:11 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:41109 "EHLO violet"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752310Ab2DEIlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:41:10 -0400
Date: Thu, 5 Apr 2012 10:37:43 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: hayeswang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 5/5] r8169: support RTL8411
Message-ID: <20120405083743.GB32027@electric-eye.fr.zoreil.com>
References: <1333089184-1773-5-git-send-email-hayeswang@realtek.com> <1333090086-1815-1-git-send-email-hayeswang@realtek.com> <20120330072521.GA11548@electric-eye.fr.zoreil.com> <52E71C7B42A44FB1A8556BB6B75CD9A0@realtek.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E71C7B42A44FB1A8556BB6B75CD9A0@realtek.com.tw>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hayeswang <hayeswang@realtek.com> :
[...]
> There is nothing to do for rtl_init_jumbo_ops. It is all right for keeping
> NULL.

Ok, I'll add it to the commit message for future reference.

> Do I need to resend this patch?

No, I'll give it a short testing and forward to David.

We have a few weeks of net-next head. If there are further changes in sight,
you may consider planning for those before the cycle ends. Otherwise they
will experience a complete kernel cycle delay.

Thanks.

-- 
Ueimor

Will code drivers for food.
