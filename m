Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1ASFdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:33:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34623
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097Ab1ASFc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:32:59 -0500
Date: Tue, 18 Jan 2011 21:33:32 -0800 (PST)
Message-Id: <20110118.213332.191380160.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, xemul@openvz.org, davidel@xmailserver.org,
        alban.crequy@collabora.co.uk, ian.molton@collabora.co.uk
Subject: Re: [PATCH] net: filter: dont block softirqs in sk_run_filter()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295372812.3290.35.camel@edumazet-laptop>
References: <1295368755-20931-1-git-send-email-ian.molton@collabora.co.uk>
	<1295371361.3290.15.camel@edumazet-laptop>
	<1295372812.3290.35.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 18 Jan 2011 18:46:52 +0100

> Packet filter (BPF) doesnt need to disable softirqs, being fully
> re-entrant and lock-less.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
