Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064Ab0JZScI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:32:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46734
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756909Ab0JZScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:32:06 -0400
Date: Tue, 26 Oct 2010 11:32:29 -0700 (PDT)
Message-Id: <20101026.113229.02280866.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-10-26
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101026181515.GD2446@tuxdriver.com>
References: <20101026181515.GD2446@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 26 Oct 2010 14:15:16 -0400

> Here are some fixes intended for 2.6.37.  Highlights are some carl9170
> fixes, a fix/cleanup for the earlier wl1251 move, various ath9k fixes,
> a mac80211 fix relating to IBSS station expiry and a cfg80211 fix
> related to processing country IEs.  One of the ath9k patches looks big,
> but it is just changing a table of register initialization values in
> order to correct a number of issues.  The associated changelogs are
> reasonably descriptive of the issues involved.
> 
> Also included is a patch from Tejun as part of his work to remove
> flush_scheduled_work().  I noticed you already included a similar
> patch from Tejun, so I figured this was acceptable as well.

Pulled, thanks John.
