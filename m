Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1A1OUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:20:17 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:48038 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab1A1OUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:20:16 -0500
Subject: Re: [PATCH 1/2] net/wireless/nl80211.c: Avoid call to
 genlmsg_cancel
From: Johannes Berg <johannes@sipsolutions.net>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1101281515410.8546@pc-004.diku.dk>
References: <1296224232-8115-1-git-send-email-julia@diku.dk>
	 <1296223267.5118.7.camel@jlt3.sipsolutions.net>
	 <Pine.LNX.4.64.1101281515410.8546@pc-004.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 15:20:05 +0100
Message-ID: <1296224405.5118.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 15:16 +0100, Julia Lawall wrote:

> > But why did you call the label differently? :)
> 
> Because out is already used in this case, and I didn't want to change all 
> of the other occurrences of nla_put_failure.  It's a bit sloppy though, 
> because this code is the actual nla_put_failure.  I can change it if you 
> prefer.

Oh, and I could've seen that from the patch itself too, I just missed
it, sorry.

johannes

