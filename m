Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab0FISRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:17:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49383
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757605Ab0FISRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:17:14 -0400
Date: Wed, 09 Jun 2010 11:17:23 -0700 (PDT)
Message-Id: <20100609.111723.183033775.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-06-08
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100608190214.GD2422@tuxdriver.com>
References: <20100608190214.GD2422@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 8 Jun 2010 15:02:14 -0400

> Dave,
> 
> Here is a flurry of fixes intended for 2.6.35.  Most of them are small
> and obvious, but there are a few exceptions...I'll include some text from
> the iwlwifi pull request:
...
> The iwlwifi bits are bigger than I would like to see, but the fixes
> seem worthwhile.  Also included is a revert of a hostap patch that
> introduced failures with some devices, a NULL pointer dereference fix,
> a memory leak fix, a fix for an incorrect check of function pointer,
> a USB ID for p54, and a fix for an association failure 'corner case'
> from Johannes.

Pulled, thanks John.

Please try to keep things a lot smaller from here on out, thank you.
