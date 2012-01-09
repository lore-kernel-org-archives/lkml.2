Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2AIHaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:30:35 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33175 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2AIHad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:30:33 -0500
MIME-Version: 1.0
In-Reply-To: <NEXT-4f0a91b3e9c7f4.40986810@nextmail.ru>
References: <NEXT-4f0a91b3e9c7f4.40986810@nextmail.ru>
Date: Mon, 9 Jan 2012 13:00:32 +0530
Message-ID: <CAD2nsn07EaAVzx-=fk1iupxfwZQc-n4O+pq41ceqCJWWDF8fxw@mail.gmail.com>
Subject: Re: ath9k crash 3.2-rc7
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: MR <g7af0ec1e3ea1e7b1@nextmail.ru>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/9 MR <g7af0ec1e3ea1e7b1@nextmail.ru>:
>
>  > > Around 23 hours have elapsed.
>  > >
>  >> WiFi seems to be working 100% of time. It is always at least lightly
>  >loaded.
>
> 45h - all OK.
>
>  > great and thanks a lot for testing!
>
> Doesn't really require _doing_ anything except building patched kernels. And
> it is in my best interest to test the driver for the WiFi card I use...
>
>  > rather than removing the suspicious code
>  > this is properly fixed by us with this patch.
>  > http://marc.info/?l=linux-wireless&m=132595161516806&w=2
>
> Ah, I saw the message and wondered whether it is the fix I needed and what
> patches should I apply.
>
> So, I am building 3.2 with two patches: over/under-flow catcher (pity that
> it seems to be on a multiple-times-per-second codepath and just leaving the
> checks there for everyone is suboptimal) and allegedely proper fix. Both
> applied OK with a small offset.

as per our assumption, we should not see those over/underflow errors,
with the patch
above mentioned. please let us know if you hit upon this warnings,
even after the proper fix.


>
>
>

-- 
shafi
