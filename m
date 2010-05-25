Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459Ab0EYXZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:25:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56862 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab0EYXZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:25:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BFC5C69.4050105@s5r6.in-berlin.de>
Date: Wed, 26 May 2010 01:25:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Julia Lawall <julia@diku.dk>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 12/27] drivers/ieee1394: Use memdup_user
References: <Pine.LNX.4.64.1005221021460.13021@ask.diku.dk>	<4BF7A31B.2040302@s5r6.in-berlin.de> <20100525153244.73069b6a.akpm@linux-foundation.org>
In-Reply-To: <20100525153244.73069b6a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 22 May 2010 11:25:47 +0200
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
>> Julia Lawall wrote:
>>> Use memdup_user when user data is immediately copied into the
>>> allocated region.
>> Looks nice.  We won't apply janitorial updates to drivers/ieee1394
>> anymore though, since it is made obsolete by drivers/firewire and to be
>> removed sooner than later.  (I will post a proposed removal schedule
>> today to make this better known.)
> 
> I don't see much point in declaring a moratorium against
> drivers/ieee1394.  Perhaps that removal will never happen.

That's a wrong impression due to us driver developers dragging the
coexistence of two driver stacks out for too long.

> Perhaps
> third parties will find reason to revert that removal and to continue
> to maintain drivers/ieee1394.  Perhaps people will take code snippets
> from drivers/ieee1394 and will move them into drivers/firewire.
> 
> The bottom line is that the patch improves the code.  And there ain't
> nothing wrong with having better code.

This code is as good as it needs to be.

Spending time on things that can be done is fun, but spending time on
things that need to be done can't hurt either.
-- 
Stefan Richter
-=====-==-=- -=-= ==-=-
http://arcgraph.de/sr/
