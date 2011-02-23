Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1BWRlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:41:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab1BWRlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:41:07 -0500
Date: Wed, 23 Feb 2011 18:40:30 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        alsa-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd for
 GFP_ATOMIC order > 0
Message-ID: <20110223174030.GT31195@random.random>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net>
 <4D6367B3.9050306@googlemail.com>
 <20110222134047.GT13092@random.random>
 <20110222161513.GC13092@random.random>
 <4D63F6C0.7060204@internode.on.net>
 <20110222194325.GE31195@random.random>
 <20110223091532.GJ15652@csn.ul.ie>
 <4D64F26D.1050803@internode.on.net>
 <20110223170117.GK15652@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223170117.GK15652@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 05:01:17PM +0000, Mel Gorman wrote:
> I regret that yet more patches are being blasted around but I hope the included
> figures will convince you to run yet-another-test. I don't know how you are
> measuring how long IRQs are being disabled and when it's a problem but it's
> what I'm more interested in right now than the kswapd CPU usage which I'm
> still in the process of gathering data to analyse.

Arthur, I suggest to apply this patch before any of my patches (just
like the kswapd-high-wmark) before testing my patches. It's orthogonal
so it can be applied at the same time.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>

Thanks,
Andrea
