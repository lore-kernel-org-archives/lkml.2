Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab1EJMl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:41:27 -0400
Received: from vostochny.stro.at ([78.47.22.85]:47032 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423Ab1EJMlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:41:25 -0400
Date: Tue, 10 May 2011 12:41:23 +0000
From: maximilian attems <max@stro.at>
To: Nuno Subtil <subtil@gmail.com>
Cc: Robert Gordon <robert@greenroomsoftware.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] deb-pkg: fix cross-compile build
Message-ID: <20110510124123.GE13278@vostochny.stro.at>
References: <1304488750-13606-1-git-send-email-subtil@gmail.com>
 <20110504204807.GB13293@sepie.suse.cz>
 <20110505090728.GC30678@vostochny.stro.at>
 <4DC2C568.9090803@greenroomsoftware.com>
 <BANLkTinjBun=TzjveEiJsEJYKH_+NRCP7Q@mail.gmail.com>
 <4DC2EB2B.1050203@greenroomsoftware.com>
 <BANLkTimApO4j-Hsvo2OCc=PnEdOhHu76OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimApO4j-Hsvo2OCc=PnEdOhHu76OA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 10:29:22PM -0700, Nuno Subtil wrote:
> It looks like your patch duplicates the arch detection logic that's
> already in create_package, except not completely. I think this is not
> desirable.
> 
> I modified your patch to isolate this logic into a separate function
> and respect the KBUILD_DEBARCH override (which mostly means I moved
> the original logic into a separate function). This should make your
> case work as well, besides respecting the KBUILD_DEBARCH override.
> 
> Maks, Michal, can you please take a look at this new patch?

thanks doing right now.

Michal please hold off until I have time to give it some runs.

-- 
maks

