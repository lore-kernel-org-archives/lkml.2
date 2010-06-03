Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab0FCMux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:50:53 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49343 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab0FCMuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:50:52 -0400
Message-ID: <4C07A51E.6090604@fusionio.com>
Date: Thu, 03 Jun 2010 14:50:38 +0200
From: Jens Axboe <jaxboe@fusionio.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
References: <20100524070552.GR23411@kernel.dk> <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com> 	<20100524173551.GU23411@kernel.dk> <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com> 	<20100524175649.GV23411@kernel.dk> <AANLkTim_yrRZG6v1tMPgefeaaI-nUa35Q-mLQpuXWJ1p@mail.gmail.com> 	<20100601074534.GL1660@kernel.dk> <AANLkTinGfonivZvofBkMzv53IJZeKbFAEMVpv96BiJ30@mail.gmail.com> 	<20100603061039.GD3564@kernel.dk> <AANLkTint7OJvmTn7d7bqTJzsCxV-VlVT46PQWVH-m73g@mail.gmail.com> 	<20100603070126.GJ3564@kernel.dk> <AANLkTilwyuE-HiY0vX5askTNi1KoeuKIldmE85WrfIqU@mail.gmail.com> 	<AANLkTin2b7qE1zo0fQWIhYIzdV26zNBjHRcNAOELpUfK@mail.gmail.com> 	<4C078610.6020901@fusionio.com> <AANLkTinhO5oRDPXyXaeAOZU3i55eBKsx4iFMOzwm98na@mail.gmail.com> <AANLkTin_8MU3AbJ_KeXr2uTxtRFJ5ABmBAyigU6m-C6u@mail.gmail.com> <4C078E2B.7090107@fusionio.com> <E1OK8fK-0007Wa-BU@pomaz-ex.szeredi.hu> <4C0793F6.4070107@fusionio.com> <E1OK9nN-0007gB-LB@pomaz-ex.szeredi.hu>
In-Reply-To: <E1OK9nN-0007gB-LB@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-03 14:45, Miklos Szeredi wrote:
> On Thu, 03 Jun 2010, Jens Axboe wrote:
>> On 2010-06-03 13:32, Miklos Szeredi wrote:
>>> On Thu, 03 Jun 2010, Jens Axboe wrote:
>>>> I looked at that when I did the original pipe-max-pages, but it seems
>>>> we're not consistent in this regard. Anyway, here's what I came up with.
>>>> Not tested yet, and I hope thunderbird doesn't fsck up the patch.
>>>
>>> Unfortunately it did (line wrap damage).
>>
>> I suspected it might. This better?
> 
> Still strips spaces at the end of lines.

:-/

> But bigger problem is, I don't know what this patch is against.
> Doesn't apply cleanly against latest git.

It's not against mainline, it's against the other patches queued up in
this area.

-- 
Jens Axboe

