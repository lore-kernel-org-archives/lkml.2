Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2KSWqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:46:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35062 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab2KSWqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:46:33 -0500
Message-ID: <50AAB6AF.60806@zytor.com>
Date: Mon, 19 Nov 2012 14:46:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 52/58] x86: vdso: Add prototypes for __vdso_* functions
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org> <1353302917-13995-53-git-send-email-josh@joshtriplett.org> <CALCETrV31ShbsGsPX6mHdtQhhn0LV9m=43NOTCcVvYd4PQyfWw@mail.gmail.com> <20121119203716.GA5041@jtriplet-mobl1> <CALCETrVQCzjui7aKfG3gYLWz_rySJuuFXwwDvzqreiZamBxz4w@mail.gmail.com>
In-Reply-To: <CALCETrVQCzjui7aKfG3gYLWz_rySJuuFXwwDvzqreiZamBxz4w@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 02:44 PM, Andy Lutomirski wrote:
>>>
>>> Acked-by: Andy Lutomirski <luto@amacapital.net>
>>>
>>> In theory, this could go in arch/x86/include/uapi/asm/vdso.h.  No one
>>> cares, I suspect, since there exactly two non-test-case users that I
>>> know of.
>>
>> If you think it makes sense to put the VDSO prototypes in that UAPI
>> header, I could prepare an alternate patch that does so.
> 
> That header doesn't actually exist.  Feel free to create it if you're
> feeling ambitious :)
> 

It would indeed be good to separate out the UAPI for the vdso.

	-hpa


