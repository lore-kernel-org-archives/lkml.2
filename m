Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2JWUQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:16:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44167 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab2JWUQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:16:32 -0400
Date: Tue, 23 Oct 2012 16:16:30 -0400 (EDT)
Message-Id: <20121023.161630.969990145069865276.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: keescook@chromium.org, linux-kernel@vger.kernel.org,
        linville@tuxdriver.com
Subject: Re: [PATCH 173/193] net/mac80211: remove CONFIG_EXPERIMENTAL
From: David Miller <davem@davemloft.net>
In-Reply-To: <1351023350.10322.21.camel@jlt4.sipsolutions.net>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-174-git-send-email-keescook@chromium.org>
	<1351023350.10322.21.camel@jlt4.sipsolutions.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 23 Oct 2012 22:15:50 +0200

> On Tue, 2012-10-23 at 13:04 -0700, Kees Cook wrote:
>> This config item has not carried much meaning for a while now and is
>> almost always enabled by default. As agreed during the Linux kernel
>> summit, remove it.
>> 
>> CC: "John W. Linville" <linville@tuxdriver.com>
>> CC: Johannes Berg <johannes@sipsolutions.net>
>> CC: "David S. Miller" <davem@davemloft.net>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Presumably somebody is going to submit a git tree with the entire series
> and you don't want me to pick up this piece, right?

He better not expect us to take this stuff.
