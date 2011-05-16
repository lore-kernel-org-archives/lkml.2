Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1EPSUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:20:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34516 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1EPSUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:20:06 -0400
Date: Mon, 16 May 2011 20:19:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Greg KH <greg@kroah.com>,
        Ingo Molnar <mingo@elte.hu>, Randy Dunlap <rdunlap@xenotime.net>,
        Frank Arnold <farnold@amd64.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>
Subject: Re: [PATCH 1/3] x86, AMD, cacheinfo: Fix fallout caused by max3
 conversion
Message-ID: <20110516181927.GH22383@aftab>
References: <1305553188-21061-1-git-send-email-bp@amd64.org>
 <1305553188-21061-2-git-send-email-bp@amd64.org>
 <20110516173128.GC13011@kroah.com>
 <20110516173816.GE22383@aftab>
 <4DD16221.1090000@zytor.com>
 <20110516174743.GF22383@aftab>
 <4DD16639.8060604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD16639.8060604@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 02:00:25PM -0400, H. Peter Anvin wrote:
> On 05/16/2011 10:47 AM, Borislav Petkov wrote:
> > On Mon, May 16, 2011 at 01:42:57PM -0400, H. Peter Anvin wrote:
> >> So are you asking for this patchset to go into .39 or .40?
> > 
> > .39 please, if possible.
> > 
> 
> At this point, ".39 and not stable" is basically an oxymoron (especially
> since .39 might very well be out before this patch makes it to Linus),
> so please clarify what you mean, then.

Strictly speaking, path 2/3 needs to be backported to stable because it
is a bugfix. The other two not so much, call them fixlets if you like.

However, if .39 is so close, queuing them for .40 so that they go in
with the upcoming merge window might be the more sensible thing to do -
it's not like we're oopsing or cannot boot without them.

So yeah, please queue them for .40, I'll put them on my backporting
TODO-list.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
