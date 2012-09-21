Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab2IUNCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:02:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49487 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2IUNCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:02:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120921135916.796d970e@bob.linux.org.uk>
References: <CAC27Lhfn+o5OWQFs6kvkaheh5cX_6jFxtJadLa8csJcfVknJLQ@mail.gmail.com>
	<20120921135916.796d970e@bob.linux.org.uk>
Date: Fri, 21 Sep 2012 15:02:39 +0200
Message-ID: <CAC27LhfvV4u1WemsvimtVGuMwwLuz8ns82-wPDe30=cq4OUkAQ@mail.gmail.com>
Subject: Re: gma500_gfx black screen
From: Markus H <hauschild.markus@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Should be fixed in the very latest 3.6-rc. I got a report from someone
> else that I could duplicate and pin down exactly. It's made somewhat
> more complicated by the fact that another bug got introduced and then
> fixed across the same period.

Oh I thought that one was irrelevant because I mixed up all the GMA600
codenames.

> Can you try the latest 3.6-rc release. The commit in question is
> "gma500: Fix regression on Oaktrail devices"

I will try 3.6-rc6 and report back.


Thanks,
Markus
