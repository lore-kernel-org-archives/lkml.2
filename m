Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab2HTXXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 19:23:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52605 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab2HTXXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 19:23:23 -0400
Message-ID: <5032C6DD.7060506@zytor.com>
Date: Mon, 20 Aug 2012 16:23:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86, microcode, AMD: Per-family patches cache
References: <20120817143035.GA25700@aftab.osrc.amd.com>
In-Reply-To: <20120817143035.GA25700@aftab.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 07:30 AM, Borislav Petkov wrote:
> Hi guys,
>
> please pull, thanks.
>
> The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:
>
>    Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)
>
> are available in the git repository at:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode-updates-for-3.7
>
> for you to fetch changes up to cd692919bed1d59a440ffaed585ebc3c9d8c3406:
>
>    x86, microcode, AMD: Rewrite patch application procedure (2012-08-17 14:17:42 +0200)
>

Hmmm... this isn't actually present on git.kernel.org, and 01/12 is 
missing from your "v0" patchset on LKML (nevermind that a "v0" 
designator screams "don't apply"...)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

