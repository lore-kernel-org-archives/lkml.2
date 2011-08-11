Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1HKFF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 01:05:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34720 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1HKFF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 01:05:26 -0400
Date: Wed, 10 Aug 2011 22:00:34 -0700 (PDT)
Message-Id: <20110810.220034.1867514011580098205.davem@davemloft.net>
To: mikew@google.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: initialize variable ecn_ok in syncookies path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313002284-2362-1-git-send-email-mikew@google.com>
References: <1313002284-2362-1-git-send-email-mikew@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 10 Aug 2011 22:00:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>
Date: Wed, 10 Aug 2011 11:51:24 -0700

> Using a gcc 4.4.3, warnings are emitted for a possibly uninitialized use
> of ecn_ok.
> 
> This can happen if cookie_check_timestamp() returns due to not
> having seen a timestamp.  Defaulting to ecn off seems like a
> reasonable thing to do in this case, so initialized ecn_ok to false.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>

Applied, thanks Mike.
