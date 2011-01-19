Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab1ASTMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:12:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:48920 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab1ASTMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:12:47 -0500
Message-ID: <4D373791.5050000@infradead.org>
Date: Wed, 19 Jan 2011 17:12:17 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: halli manjunatha <manjunatha_halli@ti.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC V10 3/7] drivers:media:radio: wl128x: FM Driver Common sources
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com> <1294745487-29138-2-git-send-email-manjunatha_halli@ti.com> <1294745487-29138-3-git-send-email-manjunatha_halli@ti.com> <1294745487-29138-4-git-send-email-manjunatha_halli@ti.com> <20110111112434.GE2385@legolas.emea.dhcp.ti.com> <AANLkTi=TF9uYEv2Y3qwMKham=K2cCxo4UOTn8Vf+S-KC@mail.gmail.com> <AANLkTimRLGYugF+2=-nFvLeXdnLOy8Morx_wxzVTt9w5@mail.gmail.com> <5fc7c1cdc4aed93c1dbe7a3d1916bb1c.squirrel@webmail.xs4all.nl> <AANLkTikRDWF5fyqixbJs+DRJN=aJGmgqmQOdVL_d9tPo@mail.gmail.com>
In-Reply-To: <AANLkTikRDWF5fyqixbJs+DRJN=aJGmgqmQOdVL_d9tPo@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manju,

Em 18-01-2011 11:19, halli manjunatha escreveu:
>  have a look at the driver it’s already reviewed by Hans Verkuil.
> Please let me know if you are okay to include this in mainline.

As I've already pointed you, just send me a pull request from your tree when
you think it is ready. I'll be reviewing it after that. There are just too much
reviews on those drivers from TI for me to dig into every single version, especially
since, on most cases, I can't really contribute much, as I don't have OMAP3/Davinci
datasheets and the required devices here for testing, and that the reviews
come from someone at TI and/or one of your customers with a real test case
scenario.

So, as agreed in the past, I just mark all those drivers with RFC at patchwork
and I wait for the driver maintainer to send me a pull request, indicating me
that you've reached on a point where the driver/patch series is ready for its
addition.

So, if you think you're ready, you just need to send a pull request to the ML.
You don't even need to c/c me on that (and please avoid doing it, otherwise
I end by having multiple copies of your pull request, flooding my email with no
good reason).

Thanks,
Mauro
