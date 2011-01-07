Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1AGJl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:41:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:42178 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1AGJl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:41:26 -0500
Date: Fri, 7 Jan 2011 10:41:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 0/10] hid-multitouch: a first step towards multitouch
 unification
In-Reply-To: <20110107011444.GA7262@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1101071040470.26685@pobox.suse.cz>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr> <20110105174927.GB2146@polaris.bitmath.org> <AANLkTikCqufvOgYqqBZLjfmtSdsgyQV4L2HyvEP07+vf@mail.gmail.com> <alpine.LNX.2.00.1101061610270.26685@pobox.suse.cz>
 <20110107011444.GA7262@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, Dmitry Torokhov wrote:

> > In case the patchset doesn't impose danger of regressions for already 
> > existing devices, we could merge this new 'unified' driver only for newly 
> > supported devices, and finish the unification in 2.6.39.
> 
> Yep, let's merge the dirver and all new devices in this round and then
> get ready to convert already supported devices in next window.

Fully agreed, as I have written elsewhere already.

Benjamin, when do you expect to have the patches for .38 ready? The merge 
window is already open, so that I could schedule the merges properly.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
