Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485Ab2JXJDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:03:16 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:48698 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933757Ab2JXJDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:03:13 -0400
Date: Wed, 24 Oct 2012 12:03:10 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Anton Vorontsov <anton.vorontsov@linaro.org>
cc: Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC 1/2] vmevent: Implement pressure attribute
In-Reply-To: <20121022112149.GA29325@lizard>
Message-ID: <alpine.LFD.2.02.1210241159590.13035@tux.localdomain>
References: <20121022111928.GA12396@lizard> <20121022112149.GA29325@lizard>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Anton Vorontsov wrote:
> This patch introduces VMEVENT_ATTR_PRESSURE, the attribute reports Linux
> virtual memory management pressure. There are three discrete levels:
> 
> VMEVENT_PRESSURE_LOW: Notifies that the system is reclaiming memory for
> new allocations. Monitoring reclaiming activity might be useful for
> maintaining overall system's cache level.
> 
> VMEVENT_PRESSURE_MED: The system is experiencing medium memory pressure,
> there is some mild swapping activity. Upon this event applications may
> decide to free any resources that can be easily reconstructed or re-read
> from a disk.

Nit:

s/VMEVENT_PRESSURE_MED/VMEVENT_PRESSUDE_MEDIUM/

Other than that, I'm OK with this. Mel and others, what are your thoughts 
on this?

Anton, have you tested this with real world scenarios? How does it stack 
up against Android's low memory killer, for example?

			Pekka
