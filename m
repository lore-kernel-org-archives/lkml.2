Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2EGUlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:41:16 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:61778 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab2EGUlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:41:14 -0400
Date: Mon, 7 May 2012 22:41:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 00/10] (no)bootmem bits for 3.5
Message-ID: <20120507204113.GD10521@merkur.ravnborg.org>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes.

> here are some (no)bootmem fixes and cleanups for 3.5.  Most of it is
> unifying allocation behaviour across bootmem and nobootmem when it
> comes to respecting the specified allocation address goal and numa.
> 
> But also refactoring the codebases of the two bootmem APIs so that we
> can think about sharing code between them again.

Could you check up on CONFIG_HAVE_ARCH_BOOTMEM use in bootmem.c too?
x86 no longer uses bootmem.c
avr define it - but to n.

So no-one is actually using this anymore.
I have sent patches to remove it from Kconfig for both x86 and avr.

I looked briefly at cleaning up bootmem.c myslef - but I felt not
familiar enough with the code to do the cleanup.

I did not check your patchset - but based on the shortlog you
did not kill HAVE_ARCH_BOOTMEM.

	Sam
