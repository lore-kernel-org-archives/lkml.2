Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0K2VuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:50:10 -0500
Received: from 1wt.eu ([62.212.114.60]:48181 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab0K2VuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:50:09 -0500
Date: Mon, 29 Nov 2010 22:49:33 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101129214933.GD8442@1wt.eu>
References: <20101116104600.GA24015@suse.de> <20101119191906.GA31760@xanatos> <AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com> <20101126074809.GD19589@elte.hu> <20101129163308.GA2383@xanatos> <20101129180429.GB14046@elte.hu> <4CF3F996.4090703@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF3F996.4090703@zytor.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:05:58AM -0800, H. Peter Anvin wrote:
> Can we please not use CAP_SYS_ADMIN for this?  Relying on CAP_SYS_ADMIN
> is worse than anything else -- it is a fixed policy hardcoded in the
> kernel, with no ability for the system owner to delegate the policy
> outward, e.g. by adding group read permission and/or chgrp the file.
> 
> Delegating CAP_SYS_ADMIN, of course, otherwise known as "everything", is
> worse than anything...

Agreed, that's why I still think that hiding lots of valuable information to
non-root users will get more users added to unmanaged sudoers files, which
will result in much more holes in the systems than we currently have.

Willy

