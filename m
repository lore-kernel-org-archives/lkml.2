Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3AENhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 08:37:17 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52534 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab3AENhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 08:37:14 -0500
MIME-Version: 1.0
In-Reply-To: <50E70E48.3010900@opengridcomputing.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
	<1357215562-6288-10-git-send-email-akinobu.mita@gmail.com>
	<50E5B183.4030706@opengridcomputing.com>
	<CAC5umygnMMC2sH2c88P_gEWTgwM=CBCUcqBbo+NX=fOZ2rEGxw@mail.gmail.com>
	<50E70E48.3010900@opengridcomputing.com>
Date: Sat, 5 Jan 2013 22:37:13 +0900
Message-ID: <CAC5umyjpA4_J-1RRv0O72GiPW5O6-1b+dypg746vOphEkpKyYw@mail.gmail.com>
Subject: Re: [PATCH -v2 09/26] infiniband: rename random32() to prandom_u32()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/5 Steve Wise <swise@opengridcomputing.com>:
> I'm asking: why are you bothering with renaming the functions?  This seems
> like a needless change, _unless_ there are really non-pseudo-random services
> being added.

We already have get_random_byte() which is not pseudo-random number
generator.

Apart from that, the naming scheme was confusing without "prandom" prefix.
Because I introduced new functions in the commit 6582c665 ("prandom:
introduce prandom_bytes() and prandom_bytes_state()").
