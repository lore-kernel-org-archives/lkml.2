Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0HDFNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 01:13:25 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:37537 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab0HDFNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 01:13:24 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
Date: Wed, 04 Aug 2010 15:12:55 +1000
From: "Bojan Smojver" <bojan@rexursive.com>
To: nigel@tuxonice.net
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
X-Mailer: LCG ProfiMail
Message-ID: <0401585627.965401975@rexursive.com>
In-Reply-To: <4C58EB41.1020808@tuxonice.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But, having said 'okay' above, I should point out that you might want to 
> select CRYPTO too, since LZO depends on it. (And perhaps I should ask 
> whether you should be using cryptoapi rather than LZO directly?)

OK, I will check. I kinda remember the docs just saying to select the 
above.

I looked at crypto briefly, but then decided to use straight compression 
because it looked a straightforward match for the task at hand.

--
Bojan 
