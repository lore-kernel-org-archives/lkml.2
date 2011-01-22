Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab1AVA6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:58:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43870
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927Ab1AVA6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:58:05 -0500
Date: Fri, 21 Jan 2011 16:58:39 -0800 (PST)
Message-Id: <20110121.165839.221575506.davem@davemloft.net>
To: alban.crequy@collabora.co.uk
Cc: eric.dumazet@gmail.com, lennart@poettering.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ian.molton@collabora.co.uk
Subject: Re: [PATCH 5/8] af_unix: find the recipients of a multicast group
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110121172420.7ac74133@chocolatine.cbg.collabora.co.uk>
References: <20110121143751.57b1453d@chocolatine.cbg.collabora.co.uk>
	<1295620788-6002-5-git-send-email-alban.crequy@collabora.co.uk>
	<20110121172420.7ac74133@chocolatine.cbg.collabora.co.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alban Crequy <alban.crequy@collabora.co.uk>
Date: Fri, 21 Jan 2011 17:24:20 +0000

> I don't know if I should avoid releasing sockets in RCU callbacks or
> update the lockdep annotations.

Releasing sockets in RCU callbacks is dangerous at best.
