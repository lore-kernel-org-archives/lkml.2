Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2BUSAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:00:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44355 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755Ab2BUR7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:59:49 -0500
Message-ID: <4F43DB69.9060509@zytor.com>
Date: Tue, 21 Feb 2012 09:59:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Josh Boyer <jwboyer@gmail.com>, Jongman Heo <jongman.heo@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com> <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com> <4F42FE08.5020309@zytor.com> <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com>
In-Reply-To: <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 09:27 PM, Linus Torvalds wrote:
> 
> IOW, if you can try this on top of current -git, that would be lovely.
> 

This passed all my build tests overnight.

I don't know if unlazy_fpu() being out of line will cause a context
switch performance loss, though.

Otherwise:

Acked-by: H. Peter Anvin <hpa@zytor.com>

Let me know if you'd prefer me to pull this into the -tip tree.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

