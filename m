Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2LSD57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 22:57:59 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:34108 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LSD5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 22:57:53 -0500
MIME-Version: 1.0
In-Reply-To: <20121216174943.GB20393@liondog.tnic>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-6-git-send-email-yinghai@kernel.org>
	<20121216174943.GB20393@liondog.tnic>
Date: Tue, 18 Dec 2012 19:57:51 -0800
X-Google-Sender-Auth: cIgDcaQ5lm1vRAFUD0onMGkdR9c
Message-ID: <CAE9FiQXb3hLUeuOZuwN62mJhF29T-PyZ7Q82-rk1bYL0jJJFFw@mail.gmail.com>
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

make the transition smooth.

zap_ident is after setting in head_64.S

anyway the whole zap_ident get deleted and we don't need this patch anymore.

Yinghai
