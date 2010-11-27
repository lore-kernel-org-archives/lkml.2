Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0K0C0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 21:26:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36554
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587Ab0K0C0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 21:26:49 -0500
Date: Fri, 26 Nov 2010 18:27:14 -0800 (PST)
Message-Id: <20101126.182714.226785459.davem@davemloft.net>
To: mhocko@suse.cz
Cc: stable@kernel.org, vegard.nossum@gmail.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, eugene@redhat.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH] af_unix: limit unix_tot_inflight
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101126085000.GA4532@tiehlicka.suse.cz>
References: <1290553918.2866.80.camel@edumazet-laptop>
	<1290590335.3464.24.camel@edumazet-laptop>
	<20101126085000.GA4532@tiehlicka.suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 26 Nov 2010 09:50:00 +0100

> Shouldn't this go to stable?
> AFAICS 2.6.32 contains the same code (the patch applies). 
> I haven't tried to reproduce the issue yet.

I'll submit it to all the stable branches after this patch (and the
other AF_UNIX fixes recently proposed) have sat in Linus's tree for at
least half a week or so.
