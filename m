Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3ADNpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 08:45:14 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:34291 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3ADNpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 08:45:11 -0500
MIME-Version: 1.0
In-Reply-To: <50E5B183.4030706@opengridcomputing.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
	<1357215562-6288-10-git-send-email-akinobu.mita@gmail.com>
	<50E5B183.4030706@opengridcomputing.com>
Date: Fri, 4 Jan 2013 22:45:08 +0900
Message-ID: <CAC5umygnMMC2sH2c88P_gEWTgwM=CBCUcqBbo+NX=fOZ2rEGxw@mail.gmail.com>
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

2013/1/4 Steve Wise <swise@opengridcomputing.com>:
> Are there other "non pseudo-random" services that warrant this rename?

I couldn't understand your question very well.  So I'm not sure this is
the expected answer:
I only renamed pseudo-random functions defined in lib/random32.c in the
commit 496f2f93 ("random32: rename random32 to prandom").
This patch series aims for finishing the naming transition and removing
the backword compatibility wrapper macros.  Non pseudo-random functions
are unrelated to this patch series.
