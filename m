Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab0EFR6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:58:46 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:49033 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab0EFR6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:58:44 -0400
Subject: Re: 2.6.34-rc5-mmotm0428 - 2 RCU whinges in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <5820.1273167313@localhost>
References: <5820.1273167313@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 19:58:16 +0200
Message-ID: <1273168696.23199.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 13:35 -0400, Valdis.Kletnieks@vt.edu wrote:
> Spotted these in my dmesg, hopefully somebody is interested...
> 
> [   54.076863] wlan0: deauthenticating from 00:11:20:a4:4c:11 by local choice (reason=3)
> [   54.080580] 
> [   54.080581] ===================================================
> [   54.080584] [ INFO: suspicious rcu_dereference_check() usage. ]
> [   54.080586] ---------------------------------------------------
> [   54.080589] net/mac80211/sta_info.c:858 invoked rcu_dereference_check() without protection!

I'm pretty sure I fixed those so there should be a patch on its way to
or in mainline somewhere.

johannes

