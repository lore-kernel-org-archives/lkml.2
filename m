Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab0DKVlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 17:41:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42355
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753022Ab0DKVla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 17:41:30 -0400
Date: Sun, 11 Apr 2010 14:41:33 -0700 (PDT)
Message-Id: <20100411.144133.193724547.davem@davemloft.net>
To: andi@firstfloor.org
Cc: cristiklein@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: add setsockopt to disable slow start after idle
From: David Miller <davem@davemloft.net>
In-Reply-To: <87hbnhbtrg.fsf@basil.nowhere.org>
References: <1270863015-19597-1-git-send-email-cristiklein@gmail.com>
	<20100409.221307.246951787.davem@davemloft.net>
	<87hbnhbtrg.fsf@basil.nowhere.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Sun, 11 Apr 2010 22:48:19 +0200

> It should be safe as long as you don't have any packet loss (which
> means the network can take it). Or I am missing something?
> 
> So perhaps allow it, but force disable it on the first retransmit?

Unless you can detect packet loss or queueing delay incurred by
everyone else on the internet, this won't work.

Look, just drop this discussion, people simply don't understand the
implications of what they are suggesting.

The only thing I am willing to consider is a per-route attribute for
this setting, because that would be another legitimate to make this
setting.

