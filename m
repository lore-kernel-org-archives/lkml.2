Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2GYUSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 16:18:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58869 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab2GYUSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 16:18:21 -0400
Message-ID: <5010547E.2090404@zytor.com>
Date: Wed, 25 Jul 2012 13:18:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/build change for v3.6
References: <20120722134451.GA7099@gmail.com> <20120722135807.GA17513@shutemov.name> <20120722142204.GA9085@gmail.com> <20120725201511.GA888@merkur.ravnborg.org>
In-Reply-To: <20120725201511.GA888@merkur.ravnborg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 01:15 PM, Sam Ravnborg wrote:
>
> This is not as expected....
> In this silly example it is maybe obvious but I have lost hours tracking
> down bugs due to this.
> You add a new target and suddenly someting unrelated breaks.
>
> What happens is that make consider the assignment a command due to the leading
> tab - and because is follows a target (or other commands).
>
> I hope this makes it clear why many makefiles in the kernel uses tabs for indent.
>

This is also a good reason why not to indent assignments in Makefiles by 
full tab stops.  A smaller indent can't be scrambled this way.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

