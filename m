Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab0FCLLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 07:11:16 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59261 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab0FCLLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 07:11:15 -0400
Message-ID: <4C078DC5.2040008@fusionio.com>
Date: Thu, 03 Jun 2010 13:11:01 +0200
From: Jens Axboe <jaxboe@fusionio.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
References: <20100524070552.GR23411@kernel.dk> <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com> 	<20100524173551.GU23411@kernel.dk> <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com> 	<20100524175649.GV23411@kernel.dk> <AANLkTim_yrRZG6v1tMPgefeaaI-nUa35Q-mLQpuXWJ1p@mail.gmail.com> 	<20100601074534.GL1660@kernel.dk> <AANLkTinGfonivZvofBkMzv53IJZeKbFAEMVpv96BiJ30@mail.gmail.com> 	<20100603061039.GD3564@kernel.dk> <AANLkTint7OJvmTn7d7bqTJzsCxV-VlVT46PQWVH-m73g@mail.gmail.com> 	<20100603070126.GJ3564@kernel.dk> <AANLkTilwyuE-HiY0vX5askTNi1KoeuKIldmE85WrfIqU@mail.gmail.com> 	<AANLkTin2b7qE1zo0fQWIhYIzdV26zNBjHRcNAOELpUfK@mail.gmail.com> 	<AANLkTiliVv0RFCeZnUy0PeWS1LNQZGzLSDFnZlf8-hgO@mail.gmail.com> 	<4C07862D.4090709@fusionio.com> <AANLkTincO5thcP-yASUtIV41TtY3ZmG9YSU-J5nT2sFg@mail.gmail.com>
In-Reply-To: <AANLkTincO5thcP-yASUtIV41TtY3ZmG9YSU-J5nT2sFg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Readding linux-kernel, switching to a new mailer after more than a
decade of mutt isn't easy...)

On 2010-06-03 12:58, Michael Kerrisk wrote:

>> the CAP_SYS_ADMIN was basically just
>> grabbed out of thin air.
> 
> Which explains why CAP_SYS_ADMIN has become the mess it is today ;-)

Definitely true :-)

-- 
Jens Axboe

