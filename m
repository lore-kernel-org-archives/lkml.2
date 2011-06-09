Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab1FIJtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:49:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:38297 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab1FIJtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:49:47 -0400
Date: Thu, 9 Jun 2011 11:49:45 +0200
From: Michal Marek <mmarek@suse.cz>
To: Peter Foley <pefoley2@verizon.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] kbuild: silence Nothing to be done for 'all' message
Message-ID: <20110609094945.GC4612@sepie.suse.cz>
References: <alpine.LNX.2.00.1106082047040.61251@linux.foleyremote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106082047040.61251@linux.foleyremote.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 08:58:32PM -0400, Peter Foley wrote:
> 
> This patch silences a Makefile.asm-generic message
> by defining a dummy rule for all. 
> 
> make -f /usr/src/git/scripts/Makefile.asm-generic \
>             obj=arch/x86/include/generated/asm
> make[1]: Nothing to be done for `all'.
> 
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  scripts/Makefile.asm-generic |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Applied to kbuild-2.6.git#rc-fixes, thanks.

Michal
