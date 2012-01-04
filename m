Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2ADBa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 20:30:59 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:45545 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2ADBa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 20:30:57 -0500
Date: Tue, 03 Jan 2012 20:27:33 -0500 (EST)
Message-Id: <20120103.202733.1070369898271428121.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@qca.qualcomm.com,
        linville@tuxdriver.com
Subject: Re: linux-next: merge of the wireless-next tree into the net-next
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120104105947.8bac77d1d7198a49e6feeca8@canb.auug.org.au>
References: <20120104105947.8bac77d1d7198a49e6feeca8@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Jan 2012 17:27:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 4 Jan 2012 10:59:47 +1100

> I noticed that the wireless-next tree has been merged into the net-next
> tree today.  Has anything been done about the build failure I reported in
> the wireless-next a while ago:
> 
> On 12/22/2011 16:58 +1100, Stephen Rothwell wrote:
>>
>> After merging the final tree, today's linux-next build (powerpc
>> allyesconfig) failed like this:
>> 
>> drivers/net/wireless/ath/ath6kl/cfg80211.c:27:1: error: expected ')' before 'KBUILD_MODNAME'
>> drivers/net/wireless/ath/ath6kl/cfg80211.c:27:1: error: 'KBUILD_MODNAME' undeclared here (not in a function)
>> drivers/net/wireless/ath/ath6kl/cfg80211.c:27:1: error: expected ',' or ';' before string constant

It happens on any platform not just powerpc, John please fix this and
don't have known unresolved -next build failures in your tree when you
push to me.
