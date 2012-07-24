Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2GXNSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:18:18 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57437 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab2GXNSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:18:17 -0400
MIME-Version: 1.0
In-Reply-To: <1343109531.7412.47.camel@marge.simpson.net>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
	<1343109531.7412.47.camel@marge.simpson.net>
Date: Tue, 24 Jul 2012 21:18:16 +0800
Message-ID: <CAJd=RBC835W52nsXCqhM_4KR3CuLF9zijh3416LiJLybTuR_YA@mail.gmail.com>
Subject: Re: [PATCH 00/34] Memory management performance backports for -stable V2
From: Hillf Danton <dhillf@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Mel Gorman <mgorman@suse.de>, Stable <stable@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 1:58 PM, Mike Galbraith <efault@gmx.de> wrote:
> FWIW, I'm all for performance backports.  They do have a downside though
> (other than the risk of bugs slipping in, or triggering latent bugs).
>
> When the next enterprise kernel is built, marketeers ask for numbers to
> make potential customers drool over, and you _can't produce any_ because
> you wedged all the spiffy performance stuff into the crusty old kernel.
>
Well do your job please.

	Suse 11 SP1 kernel panic on HP hardware
	https://lkml.org/lkml/2012/7/24/136
