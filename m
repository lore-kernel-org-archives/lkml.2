Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab2DYKCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:02:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:18005 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab2DYKC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:02:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92893689"
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 0/4] kbuild: Move vmlinux link out of top-level Makefile
In-Reply-To: <20120424194148.GA2216@merkur.ravnborg.org> (Sam Ravnborg's
	message of "Tue, 24 Apr 2012 21:41:48 +0200")
References: <20120424194148.GA2216@merkur.ravnborg.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Wed, 25 Apr 2012 03:02:27 -0700
Message-ID: <m2haw8m8ng.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
