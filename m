Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab1H3SBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:01:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53931 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab1H3SBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:01:22 -0400
Date: Tue, 30 Aug 2011 13:55:02 -0400 (EDT)
Message-Id: <20110830.135502.179848097213434762.davem@davemloft.net>
To: kaber@trash.net
Cc: joe@perches.com, bart.de.schuymer@pandora.be, wensong@linux-vs.org,
        horms@verge.net.au, ja@ssi.bg, shemminger@linux-foundation.org,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org
Subject: Re: [PATCH 06/24] netfilter: Remove unnecessary OOM logging
 messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E5CDBAA.6040001@trash.net>
References: <cover.1314650069.git.joe@perches.com>
	<13c1c12486cae409dfa5254b1435e660f2b17e05.1314650069.git.joe@perches.com>
	<4E5CDBAA.6040001@trash.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 30 Aug 2011 10:55:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 30 Aug 2011 14:46:34 +0200

> On 29.08.2011 23:17, Joe Perches wrote:
>> Removing unnecessary messages saves code and text.
>> 
>> Site specific OOM messages are duplications of a generic MM
>> out of memory message and aren't really useful, so just
>> delete them.
> 
> Looks good to me. Do you want me to apply this patch or are you
> intending to have the entire series go through Dave?

I'm happy with subsystem folks taking things in if they want, the
B.A.T.M.A.N. guys did this earlier today for example.
