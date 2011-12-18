Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1LRUzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 15:55:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab1LRUzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 15:55:09 -0500
Date: Sun, 18 Dec 2011 21:55:07 +0100
From: Michal Marek <mmarek@suse.cz>
To: Peter Foley <pefoley2@verizon.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] kbuild: use xfwrite wrapper function to silence warnings
Message-ID: <20111218205507.GA25931@sepie.suse.cz>
References: <alpine.LNX.2.00.1110221045310.59156@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1110221045310.59156@linux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 10:48:49AM -0400, Peter Foley wrote:
> Use the xfwrite wrapper function defined in lkc.h to check the return value of
> fwrite and silence these warnings.
> 
>   HOSTCC  scripts/kconfig/zconf.tab.o
> scripts/kconfig/zconf.tab.c: In function 'header_print_comment':
> /usr/src/lto/scripts/kconfig/confdata.c:551:10: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result
> scripts/kconfig/zconf.tab.c: In function 'kconfig_print_comment':
> /usr/src/lto/scripts/kconfig/confdata.c:467:10: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  scripts/kconfig/confdata.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Applied to kbuild.git#kconfig, thanks.

Michal
