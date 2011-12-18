Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab1LRU52 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 15:57:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab1LRU50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 15:57:26 -0500
Date: Sun, 18 Dec 2011 21:57:25 +0100
From: Michal Marek <mmarek@suse.cz>
To: Peter Foley <pefoley2@verizon.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] kbuild: don't use a symlink for update-po-config
Message-ID: <20111218205725.GB25931@sepie.suse.cz>
References: <alpine.LNX.2.00.1110221117380.59156@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1110221117380.59156@linux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 11:19:22AM -0400, Peter Foley wrote:
> This patch changes update-po-config to not create a symlink in arch/um 
> because this fails with make O= builds.
> It also improves the V=0 output. 
> 
>   GEN     /usr/src/lto/work/Makefile
>   GEN config
> ln: failed to create symbolic link `arch/um/Kconfig': No such file or directory
> make[3]: *** [update-po-config] Error 1
> make[2]: *** [update-po-config] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  scripts/kconfig/Makefile |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)

Applied to kbuild.git#kconfig, thanks.

Michal
