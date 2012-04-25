Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab2DYKBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:01:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:12137 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861Ab2DYKBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:01:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="135111164"
From: Andi Kleen <andi@firstfloor.org>
Cc: linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] kbuild: Move vmlinux link out of top-level Makefile
References: <20120424194148.GA2216@merkur.ravnborg.org>
5ATo: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 25 Apr 2012 03:01:45 -0700
In-Reply-To: <20120424194148.GA2216@merkur.ravnborg.org> (Sam Ravnborg's
	message of "Tue, 24 Apr 2012 21:41:48 +0200")
Message-ID: <m2ipgom8om.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:
>
> What we loose by the conversion:
> - We no longer rebuild if options to ld changes.

I think that's a problem. Can that be fixed somehow?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
