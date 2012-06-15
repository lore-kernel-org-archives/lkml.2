Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab2FOKsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:48:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38356 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756449Ab2FOKsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:48:39 -0400
Message-ID: <1339757319.24527.21.camel@joe2Laptop>
Subject: Re: [PATCH wireless-next 00/20] Use pr_<level>
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        libertas-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 03:48:39 -0700
In-Reply-To: <1339745811.4512.0.camel@jlt3.sipsolutions.net>
References: <cover.1339739415.git.joe@perches.com>
	 (sfid-20120615_080311_586023_85E50A2D) <1339745811.4512.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 09:36 +0200, Johannes Berg wrote:
> On Thu, 2012-06-14 at 22:53 -0700, Joe Perches wrote:
> > Update logging style
> 
> So ... since we make everybody else explain *why* they make a change, I
> think you should too.

To improve logging style consistency.
To reduce logging defects.
To standardize logging prefixes.
To tee up conversions of:
	pr_<level>("%s: ...", ([truct netdevice *]foo)->name, ...)
to
	netdev_<level>(foo, "...", ...) 

