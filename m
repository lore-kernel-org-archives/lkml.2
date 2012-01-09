Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2AIH5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:57:10 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65194 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2AIH5I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:57:08 -0500
MIME-Version: 1.0
In-Reply-To: <NEXT-4f0a99de7f4ef4.35302262@nextmail.ru>
References: <NEXT-4f0a99de7f4ef4.35302262@nextmail.ru>
Date: Mon, 9 Jan 2012 13:27:07 +0530
Message-ID: <CAD2nsn2MH7yXWZML5byD1_RW1d0E2Q2rhmnOBHei5iUVPU_ukA@mail.gmail.com>
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
>  >> So, I am building 3.2 with two patches: over/under-flow catcher (pity
>  >that
>  >> it seems to be on a multiple-times-per-second codepath and just leaving
>  >the
>  > > checks there for everyone is suboptimal) and allegedely proper fix. Both
>  > > applied OK with a small offset.
>  >
>  > as per our assumption, we should not see those over/underflow errors,
>  > with the patch
>  > above mentioned. please let us know if you hit upon this warnings,
>  > even after the proper fix.
>
> In my experience (and as I understand the situation) if garbage is writen to
> the "chan", it is caught by the check and device is dead-until-reboot anyway.
> On 3.0, even without checks device was dead-until-reboot, but no crash
> happened. All these checks do is converting "panic" to "WiFi broken" for 3.2.
>

true those checks are to confirm that 'chan' is corrupted and the
patch is to fix it.

-- 
shafi
