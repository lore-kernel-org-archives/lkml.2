Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2LQS6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:58:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49351 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab2LQS6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:58:08 -0500
Message-ID: <50CF6B16.1030807@zytor.com>
Date: Mon, 17 Dec 2012 10:57:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: Andy Lutomirski <luto@amacapital.net>, aarcange@redhat.com,
        ak@linux.intel.com, Stefani Seibold <stefani@seibold.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org, criu@openvz.org,
        mingo@redhat.com, john.stultz@linaro.org, tglx@linutronix.de
Subject: Re: [CRIU] [PATCH] Add VDSO time function support for x86 32-bit
 kernel
References: <1355343572-23074-1-git-send-email-stefani@seibold.net> <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com> <1355379433.24701.1.camel@wall-e> <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com> <1355383038.18653.2.camel@wall-e> <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com> <50CA6E4C.6000305@zytor.com> <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com> <50CA81A4.9040702@zytor.com> <CALCETrWCMQys5MCbd6E_7c+Bsvph5cfkrDDm5tNpyBdgVE-YeQ@mail.gmail.com> <50CA85BD.7070502@zytor.com> <CALCETrWKDJd1T_VCRNAzD-KTtYBbmvgE_ZYvb8uN4nBUYQvkgA@mail.gmail.com> <8c3585bc-fc7d-4826-913c-f4581494d91d@email.android.com> <CALCETrX5KUiQaV7dsAFa1SYyWPjUVwh43HvbPwqPStMxqE0ctQ@mail.gmail.com> <50CAE485.5020608@parallels.com> <50CB716D.6020501@zytor.com> <CALCETrWazriQVbQPc8u+KFyNUaa=kJUc=jdh9w7z6rS+kWEX1w@mail.gmail.com> <50CEE06B.9040508@parallels.com> <fb2e871b-3e2a-4e96-9eb9-cb2dd4f66eaa@email.android! .com> <50CF6ACC.4090701@parallels!
 .com>
In-Reply-To: <50CF6ACC.4090701@parallels.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 10:56 AM, Pavel Emelyanov wrote:
> On 12/17/2012 07:21 PM, H. Peter Anvin wrote:
>> Because it is almost impossible to do right?
> 
> In the generic case -- I tend to agree. But it's possible to describe
> how a library should communicate to crtools to make it possible.
> 
> Anyway, what I wanted to say -- we didn't have this scenario in our
> plans, but criu project is open, and if someone comes with sane idea,
> we will not object merging it.
> 

I doubt it is possible using existing compiler toolchains.

	-hpa


