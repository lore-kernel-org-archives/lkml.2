Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab1KIU4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:56:35 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:43607 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab1KIU4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:56:34 -0500
Date: Wed, 09 Nov 2011 15:56:28 -0500 (EST)
Message-Id: <20111109.155628.2133280930792807223.davem@davemloft.net>
To: nbowler@elliptictech.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] AH fixes for asynchronous hash algorithms.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320790365-29152-1-git-send-email-nbowler@elliptictech.com>
References: <1320790365-29152-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 09 Nov 2011 12:56:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Bowler <nbowler@elliptictech.com>
Date: Tue,  8 Nov 2011 17:12:43 -0500

> Here are two fixes for AH when using an asynchronous hmac driver.  Both
> are -stable candidates as these problems appear to have been present
> since AH was converted to use ahash way back in 2.6.33.
> 
> These code paths are not exercised when using the default software hash
> implementations which do not use the ahash callbacks, but the issues can be
> reproduced by using cryptd to create an asynchronous hash algorithm for
> testing.
> 
> This driver could probably do with some cleanups to reduce the code
> duplication (and thus test coverage) between the asynchronous callbacks
> and synchronous code paths, which should help avoid these kind of
> problems in the future.  These code paths apparently do not see a
> lot of testing.  But that's for a later patch series.
> 
> Nick Bowler (2):
>   ah: Correctly pass error codes in ahash output callback.
>   ah: Read nexthdr value before overwriting it in ahash input callback.

Thanks a lot for these bug fixes Nick, both applied.

Also queued up for -stable.
