Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab2HVWs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 18:48:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47114 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab2HVWsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 18:48:21 -0400
Message-ID: <503561A1.2040007@zytor.com>
Date: Wed, 22 Aug 2012 15:48:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86, microcode, AMD: Per-family patches cache
References: <20120817143035.GA25700@aftab.osrc.amd.com> <5032C6DD.7060506@zytor.com> <20120821091639.GA20468@aftab.osrc.amd.com>
In-Reply-To: <20120821091639.GA20468@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 02:16 AM, Borislav Petkov wrote:
> On Mon, Aug 20, 2012 at 04:23:09PM -0700, H. Peter Anvin wrote:
>>> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode-updates-for-3.7
>>>
>> Hmmm... this isn't actually present on git.kernel.org, and 01/12
>> is missing from your "v0" patchset on LKML (nevermind that a "v0"
>> designator screams "don't apply"...)
> 
> Hmm, that's actually the tag and it is there:
> 
> http://git.kernel.org/?p=linux/kernel/git/bp/bp.git;a=tag;h=334a50f04aab22cb03c59e3ff333fe81a531a85c
> 
> I tried this locally, here's what I did:
> 
> $ git remote add bp git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git
> 
> $ git fetch bp
> remote: Counting objects: 3, done.
> remote: Compressing objects: 100% (3/3), done.
> remote: Total 3 (delta 0), reused 0 (delta 0)
> Unpacking objects: 100% (3/3), done.
> From git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp
>  * [new branch]                for-next   -> bp/for-next
>  * [new branch]                master     -> bp/master
>  * [new tag]                   l3-fix-for-3.5 -> l3-fix-for-3.5
>  * [new tag]                   mce-fix-for-3.4 -> mce-fix-for-3.4
>  * [new tag]                   microcode-fix-for-3.4 -> microcode-fix-for-3.4
> 
> $ git fetch --tags bp
> remote: Counting objects: 155, done.
> remote: Compressing objects: 100% (99/99), done.
> remote: Total 118 (delta 92), reused 17 (delta 15)
> Receiving objects: 100% (118/118), 22.42 KiB, done.
> Resolving deltas: 100% (92/92), completed with 20 local objects.
> From git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp
>  * [new tag]                   amd-rdmsr-cleanups-for-3.6 -> amd-rdmsr-cleanups-for-3.6
>  * [new tag]                   microcode-updates-for-3.7 -> microcode-updates-for-3.7
> 

Weird.  I have never had to git fetch --tags before...

	-hpa

