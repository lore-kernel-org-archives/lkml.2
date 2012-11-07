Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2KGXLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 18:11:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49632 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2KGXLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 18:11:06 -0500
MIME-Version: 1.0
In-Reply-To: <50904e5125023a741@agluck-desk.sc.intel.com>
References: <50904e5125023a741@agluck-desk.sc.intel.com>
Date: Wed, 7 Nov 2012 15:11:03 -0800
Message-ID: <CA+8MBb+6_nVF+HbEtORkHFUT5kcpDeFzBbXDoMGnaaeRATGb5g@mail.gmail.com>
Subject: Re: [GIT PULL] Fix a cmci discovery problem
From: Tony Luck <tony.luck@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, tangchen@cn.fujitsu.com,
        miaox@cn.fujitsu.com, bp@alien8.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Is there a problem with this pull request ... or did it just get lost
in the LKML noise?

-Tony

On Tue, Oct 30, 2012 at 3:01 PM, Luck, Tony <tony.luck@intel.com> wrote:
> The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:
>
>   Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-tangchen
>
> for you to fetch changes up to 85b97637bb40a9f486459dd254598759af9c3d50:
>
>   x86/mce: Do not change worker's running cpu in cmci_rediscover(). (2012-10-30 14:38:12 -0700)
>
> ----------------------------------------------------------------
> Fix problem in CMCI rediscovery code that was illegally
> migrating worker threads to other cpus.
>
> ----------------------------------------------------------------
> Tang Chen (1):
>       x86/mce: Do not change worker's running cpu in cmci_rediscover().
>
>  arch/x86/kernel/cpu/mcheck/mce_intel.c |   31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
