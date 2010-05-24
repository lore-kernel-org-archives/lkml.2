Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0EXIOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 04:14:52 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:55847 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab0EXIOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 04:14:50 -0400
Subject: Re: [linux-pm] [Regression][git head f4b87dee9] ath9k doesn't work
 correctly after resume from suspend to RAM
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-pm@lists.linux-foundation.org, linux-wireless@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Daniel Yingqiang Ma <yma.cool@gmail.com>,
       David Miller <davem@davemloft.net>
In-Reply-To: <201005240059.57921.rjw@sisk.pl>
References: <201005222353.26920.rjw@sisk.pl>
	 <201005230013.37578.rjw@sisk.pl> <201005232120.16814.rjw@sisk.pl>
	 <201005240059.57921.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 10:14:29 +0200
Message-ID: <1274688869.3743.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 00:59 +0200, Rafael J. Wysocki wrote:

> commit 03ceedea972a82d343fa5c2528b3952fa9e615d5
> Author: Daniel Yingqiang Ma <yma.cool@gmail.com>
> Date:   Tue Apr 13 15:12:07 2010 +0800
> 
>     ath9k: Group Key fix for VAPs
> 
> also fixes the resume issue with iwlagn.

Ok that had me going WTF.

But then I saw that a huge ath9k patch had a mac80211 change sneakily
hidden in it. WTF!

> So, please revert.

Indeed, this patch needs to be reverted. That mac80211 change is wrong
and completely unnecessary.

johannes

