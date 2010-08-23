Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab0HWK4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:56:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab0HWK4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:56:33 -0400
Message-ID: <4C7253DF.7050802@suse.cz>
Date: Mon, 23 Aug 2010 12:56:31 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, JBeulich@novell.com,
        amwang@redhat.com, sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild fixes for 2.6.36-rc2
References: <20100821201350.GA9144@sepie.suse.cz>
In-Reply-To: <20100821201350.GA9144@sepie.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.8.2010 22:13, Michal Marek wrote:
> Hi Linus,
>
> there are some post-rc1 kbuild fixes:
> * Two kconfig fixes by Sam.
> * A fix for new make version by Jan (this is technically no a rc1
>    regression, but we should fix it sooner rather than later).
> * Two setlocalversion fixes, one by Amerigo, one by me.

Postfix on my machine died, so I missed -rc2 unfortunately. Can you 
please pull for -rc3. Thanks.

Michal


> The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:
>
>    Linux 2.6.36-rc1 (2010-08-15 17:41:37 -0700)
>
> are available in the git repository at:
>    git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes
>
> Amerigo Wang (1):
>        makefile: not need to regenerate kernel.release file when make kernelrelease
>
> Jan Beulich (1):
>        fixes for using make 3.82
>
> Michal Marek (2):
>        Merge commit 'v2.6.36-rc1' into kbuild/rc-fixes
>        setlocalversion: Ignote SCMs above the linux source tree
>
> Sam Ravnborg (2):
>        kconfig: fix savedefconfig with choice marked optional
>        kconfig: fix segfault when detecting recursive dependency
>
>   Makefile                   |    4 ++--
>   firmware/Makefile          |    2 +-
>   scripts/kconfig/confdata.c |    6 ++++--
>   scripts/kconfig/symbol.c   |    2 ++
>   scripts/mkmakefile         |    4 +++-
>   scripts/setlocalversion    |    4 ++--
>   6 files changed, 14 insertions(+), 8 deletions(-)

