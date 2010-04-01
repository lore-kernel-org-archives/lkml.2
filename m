Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab0DACdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:33:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56849
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752635Ab0DACdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:33:47 -0400
Date: Wed, 31 Mar 2010 19:33:48 -0700 (PDT)
Message-Id: <20100331.193348.196563619.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: davem@davemloft.nt, linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-03-31
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100331144649.GC3024@tuxdriver.com>
References: <20100331144649.GC3024@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 31 Mar 2010 10:46:49 -0400

> Here is a batch of fixes intended for 2.6.34.  Included are a few
> device IDs, along with several almost-one-liners to fix a variety of
> issues, including a NULL deref, a potential overflow, a misues of the
> USB API, a regulatory error for iwlwifi, a race condition in mac80211,
> and some other more minor fixes.
> 
> I saw your note about only "eats someones disk" bugs.  I'm not
> sure all of these meet that test, but I hope you will take them.
> I've been sitting on them a while and letting them cook in linux-next,
> mostly to test one particular patch (which I backed-out yesterday).
> I promise I'll tighten-up after this batch! :-)

Ok, pulled, thanks John.
