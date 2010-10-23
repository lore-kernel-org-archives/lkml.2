Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab0JWSje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 14:39:34 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58186 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563Ab0JWSjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 14:39:33 -0400
Message-ID: <4CC32BE3.1090205@kernel.dk>
Date: Sat, 23 Oct 2010 20:39:31 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Corrado Zoccolo <czoccolo@gmail.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq: improve fsync performance for small files
References: <201007202209.04627.czoccolo@gmail.com>	<AANLkTinajj76EBUQE6RXeQmZ9AEWU1g3x+pyW3Cmku0x@mail.gmail.com>	<4C976060.1010008@kernel.dk> <AANLkTinuxKZd=r=U1y-8uAQBGSDootaZLznCmJgTHBFy@mail.gmail.com>
In-Reply-To: <AANLkTinuxKZd=r=U1y-8uAQBGSDootaZLznCmJgTHBFy@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-23 19:30, Corrado Zoccolo wrote:
> Hi Jens,
> I've not seen this patch in your pull request to Linus for .37.
> Any problem with it during test?

Nope, Linus pulled it yesterday, it's now upstream. It was in the
for-2.6.37/core bits.

-- 
Jens Axboe

