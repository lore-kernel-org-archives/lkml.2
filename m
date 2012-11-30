Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031506Ab2K3T4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:56:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36424 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030207Ab2K3T4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:56:16 -0500
Message-ID: <50B90F4F.7070400@zytor.com>
Date: Fri, 30 Nov 2012 11:55:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vincent Palatin <vpalatin@chromium.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Duncan Laurie <dlaurie@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] x86, fpu: avoid FPU lazy restore after suspend
References: <1354301523-5252-1-git-send-email-vpalatin@chromium.org> <1354301523-5252-2-git-send-email-vpalatin@chromium.org> <CA+55aFz4M4GmQbUkD1dhTkLTYka4H+T_phrsXgx+eGe8g9iLYA@mail.gmail.com> <50B90B31.3000907@zytor.com> <CA+55aFyoAq+w6eNAyOJ00cpFEaGE=eKzMMtr9kEtMuUU820oYg@mail.gmail.com> <50B90E4D.8010604@zytor.com> <CAP_ceTxmMhQeDi=x9HmYke85hKMg3_YhbXSnfDC12rOcocQJpA@mail.gmail.com>
In-Reply-To: <CAP_ceTxmMhQeDi=x9HmYke85hKMg3_YhbXSnfDC12rOcocQJpA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 11:54 AM, Vincent Palatin wrote:
>>
> I have done a patch v2 according to your suggestions.
> I will run the testing on it now.
> I probably need at least 2 to 3 hours to validate it.
> 

That would be super.  Let me know and I'll queue it up and send a pull
request with this and a few more urgent things to Linus.

	-hpa


