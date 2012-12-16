Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2LPSEE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 13:04:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51733 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2LPSEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 13:04:02 -0500
MIME-Version: 1.0
In-Reply-To: <20121216174943.GB20393@liondog.tnic>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-6-git-send-email-yinghai@kernel.org>
	<20121216174943.GB20393@liondog.tnic>
Date: Sun, 16 Dec 2012 10:04:01 -0800
X-Google-Sender-Auth: GY4o2u3Js3-c0565_FA0gy_6NG4
Message-ID: <CAE9FiQXksVZ-7qVZNw8W-be1J7sDCeciotd-_LxKkjBYVmSRDg@mail.gmail.com>
Subject: Re: [PATCH v6 05/27] x86, 64bit: clear ident mapping when kernel is
 above 512G
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 9:49 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Dec 13, 2012 at 02:01:59PM -0800, Yinghai Lu wrote:
>> After following patch:
>>       x86, 64bit: Set extra ident mapping for whole kernel range
>>
>> We have extra ident mapping for kernel that is loaded above 1G.
>
> What?
>
> /me looks at next patch
>
> Aaah, the *next* patch adds an extra ident mapping. Why don't you say
> so?
>
>> So need to clear extra pgd entry when kernel is loaded above 512g.
>
> Why then isn't that patch following the next patch instead of coming
> before it?
>

thanks a lot for checking the patch.
this patch is obsolete by #PF handler version.

so if possible, you can check my for-x86-boot branch instead.
   http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=shortlog;h=refs/heads/for-x86-boot

   git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-boot

will repost them after HPA is ok with my changes to his #PF handler patch.


Thanks

Yinghai
