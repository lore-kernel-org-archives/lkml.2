Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab2FSTS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:18:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42658 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2FSTSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:18:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5182ZzmmQXci=n=YZrktS6hUWq=Dq9bqDpA9KFpP3VnQ@mail.gmail.com>
References: <alpine.LFD.2.02.1206152313310.3086@ionos> <CAErSpo5182ZzmmQXci=n=YZrktS6hUWq=Dq9bqDpA9KFpP3VnQ@mail.gmail.com>
From: Roland Dreier <roland@kernel.org>
Date: Tue, 19 Jun 2012 12:18:33 -0700
X-Google-Sender-Auth: vDTwJFhO8AWa4kumQl6JHuFes3Q
Message-ID: <CAG4TOxM68FqsXCjJJji_hcPq25Wfg0jQDLXfV3hU=P9F3x65Tw@mail.gmail.com>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the question!
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        ksummit-2012-discuss@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 8:45 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> We can try to address this by "educating developers" or "documenting
> the design better" or "delegating to submaintainers" or whatever.
> Those are valuable, but in some way they're cop-outs.  A more
> effective fix would be to remove the landmines, reduce complexity, and
> improve the design.  If we have coherent code that follows the
> hardware architecture and matches people's intuition about how things
> "should work," I think we'll get patches with fewer issues.
>
> Sorry, I think I just reiterated what you, Greg KH, Alan, et al have
> already said :)

No, I don't think that's just reiteration, I think it's an important point :)

There is a certain strain of thinking in our community that is resistant
to working on design improvements as you describe.  And I think without
improving in that direction, we're going to drown in subtly broken patches.

 - R.
