Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2GPXBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 19:01:36 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49868 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab2GPXBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 19:01:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1207161130080.26923@trent.utfs.org>
References: <1341817465.4579.5.camel@ThinkPad-T420>
	<20120711154232.165cbca9.akpm@linux-foundation.org>
	<CABE8wwsqyo=BPCy4xy1PAVKFWe=GqYRdYowXkQ6UZoXdtEdCZA@mail.gmail.com>
	<1342086988.4091.44.camel@ThinkPad-T420>
	<alpine.DEB.2.01.1207161130080.26923@trent.utfs.org>
Date: Mon, 16 Jul 2012 16:01:33 -0700
Message-ID: <CAA9_cmf-5CW0KW=721Hh3GCKGgQYsJo1UX3AFbG+7c4fTGw-Yw@mail.gmail.com>
Subject: Re: [PATCH RESEND] Fix a dead loop in async_synchronize_full()
From: Dan Williams <dan.j.williams@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, arjan@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, JBottomley@parallels.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 11:32 AM, Christian Kujau <lists@nerdbynature.de> wrote:
> Is this still scheduled to go into 3.5? I'm asking because -rc7 has been
> released and does not contain this fix. W/o this fix, my powerpc system
> won't boot[0] :-\

I don't expect James is going to push my async changes for 3.5.  So
maybe we should go with Zhong's smaller fix for 3.5 and then replace
with the ASYNC_DOMAIN patches in 3.6?

--
Dan
