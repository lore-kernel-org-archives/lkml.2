Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab2EIOjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:39:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203Ab2EIOjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:39:52 -0400
Date: Wed, 9 May 2012 16:39:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] Bug fix and win8 for hid-multitouch 
In-Reply-To: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1205091637570.26736@pobox.suse.cz>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2012, benjamin.tissoires wrote:

> The first patch fixes the bug I discovered lately. This bug was related to the out
> of bound bitfield test, so it concerns every known devices. Ideally, it should go
> to upstream-fixes, but this would requires additional adaptations.
> Jiri, How do you want to proceed?

When did the bug get introduced, please? i.e. is it a regression?

As we are getting close to 3.5 merge window being open, maybe the best 
thing to do would be just push it there once it's open, and then 
eventually backport it for stable@ if necessary.

> The last 4 patches are the beginning of the support of Win8 devices. 
> It's only the beginning as the specification is much more precise than 
> the Win7, and we will need to do more tuning in the future. However, 
> Win8 devices are retro-compatible with Win7, so they will work out of 
> the box though.

I understand that Henrik had some valid concerns, so I will wait for a 
second respin and Henrik's ack, ok?

Thanks,

-- 
Jiri Kosina
SUSE Labs
