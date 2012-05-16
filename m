Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2EPPWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:22:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38958 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754205Ab2EPPWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:22:52 -0400
Message-ID: <1337181771.4818.0.camel@joe2Laptop>
Subject: Re: [PATCH 0/3] net: mac80211: Neaten debugging
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 May 2012 08:22:51 -0700
In-Reply-To: <1337155171.4367.2.camel@jlt3.sipsolutions.net>
References: <1337106548.15553.8.camel@jlt3.sipsolutions.net>
	 <cover.1337116578.git.joe@perches.com>
	 <20120516.012319.1903390658912592000.davem@davemloft.net>
	 <1337155171.4367.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 09:59 +0200, Johannes Berg wrote:
> I wonder if it makes sense to leave these under
> #ifdef though? Why #ifdef something if it's going to be invisible most
> of the time anyway?

I don't understand your point.
#ifdef removal is a good thing.

