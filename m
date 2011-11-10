Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab1KJI21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:28:27 -0500
Received: from gw1.transmode.se ([195.58.98.146]:55485 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127Ab1KJI2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:28:25 -0500
In-Reply-To: <049d01cc9f6d$c962f8a0$5c28e9e0$@systemfabricworks.com>
References: <1320312505-30612-1-git-send-email-Joakim.Tjernlund@transmode.se> <20111109161539.b2cdf381.akpm@linux-foundation.org> <049d01cc9f6d$c962f8a0$5c28e9e0$@systemfabricworks.com>
Subject: RE: [PATCH] crc32: Optimize inner loop.
X-KeepSent: 379E7B25:DD8B41D5-C1257944:002E2296;
 type=4; name=$KeepSent
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Frank Zago'" <fzago@systemfabricworks.com>,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF379E7B25.DD8B41D5-ONC1257944.002E2296-C1257944.002E8AB3@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Thu, 10 Nov 2011 09:28:21 +0100
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3|September 15, 2011) at
 11/10/2011 09:28:22
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/11/10 06:58:35:
>
> >
> > I meant to ask about that.  The discussion was fairly long and complex
> > and I'm now unsure whether the patch I have is a still up-to-date,
> > whether it is a good one, whether it has additional testing results,
> > etc.
>
> The original patch that went into your mm tree was replaced by a cleaner one
> over time but the review process went on and on and I had to spend more time
> with my day job. Eventually I just couldn't figure out how to get everyone
> any happier. I was really reluctant to give up performance on the Intel
> platform
> but we were mostly arguing about 2-3% give or take.

As I recall I was happy with your last round(possibly some minor nits) and
you were going to submit a final round to be included by Andrew.

>
> It seems that the folks that wanted the same algorithm for crc32c may have
> figured out how to reach a compromise.

crc32c are based on your patches and can't move on until your work
is applied.

 Jocke

