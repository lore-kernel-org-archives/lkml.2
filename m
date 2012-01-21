Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab2AUSg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:36:28 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:54783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2AUSg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:36:27 -0500
Subject: Re: [PATCH] scripts/kernel-doc: fix fatal error caused by
 cfg80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4F1B049A.1020409@xenotime.net>
References: <4F1B049A.1020409@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Jan 2012 19:36:22 +0100
Message-ID: <1327170982.3528.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-21 at 10:31 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> include/net/cfg80211.h uses __must_check in functions that
> have kernel-doc notation.  This was confusing scripts/kernel-doc,
> so have scripts/kernel-doc ignore "__must_check".
> 
> Error(include/net/cfg80211.h:2702): cannot understand prototype: 'struct cfg80211_bss * __must_check cfg80211_inform_bss(...)

Thanks Randy, I'd seen this a little while ago but not gotten around to
investigating.

johannes


