Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734Ab2EPH7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:59:41 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:58475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965135Ab2EPH7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:59:38 -0400
Message-ID: <1337155171.4367.2.camel@jlt3.sipsolutions.net>
Subject: Re: [PATCH 0/3] net: mac80211: Neaten debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 16 May 2012 09:59:31 +0200
In-Reply-To: <20120516.012319.1903390658912592000.davem@davemloft.net>
References: <1337106548.15553.8.camel@jlt3.sipsolutions.net>
	 <cover.1337116578.git.joe@perches.com>
	 <20120516.012319.1903390658912592000.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 01:23 -0400, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Tue, 15 May 2012 14:20:29 -0700
> 
> > Always use pr_debug variants instead of printk(KERN_DEBUG...)
> > 
> > Joe Perches (3):
> >   net: mac80211: Convert printk(KERN_DEBUG to pr_debug
> >   net: mac80211: Add and use ht_vdbg debugging macro
> >   net: mac80211: Add and use ibss_vdbg debugging macro
> 
> I really think this is the right thing to do and I hope the wireless
> folks integrate this.
> 
> I am well aware that you guys intend for some of these messages to be
> indications and notifications the user is intended to SEE, but in the
> cases where that is true KERN_DEBUG is absolutely not appropriate.
> 
> You should be using KERN_INFO or KERN_WARN in those situations
> instead.

Yeah, makes sense. I wonder if it makes sense to leave these under
#ifdef though? Why #ifdef something if it's going to be invisible most
of the time anyway?

johannes

