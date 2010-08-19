Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab0HSTjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 15:39:48 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:47236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab0HSTjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 15:39:47 -0400
Subject: Re: [RFC patch] include/net/cfg80211.h: wiphy_<level> messages use
 dev_printk
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1282245848.6724.261.camel@Joe-Laptop>
References: <1282245848.6724.261.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 21:39:44 +0200
Message-ID: <1282246784.4507.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 12:24 -0700, Joe Perches wrote:
> Adding device to the wiphy logging messages could be useful.
>  
>  #define wiphy_printk(level, wiphy, format, args...)		\
> -	printk(level "%s: " format, wiphy_name(wiphy), ##args)
> +	dev_printk(level, &wiphy->dev, "%s: " format, wiphy_name(wiphy), ##args)

what will that actually print?

johannes

