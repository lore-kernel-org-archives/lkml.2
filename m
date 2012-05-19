Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab2ESSMp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:12:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54576 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab2ESSMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:12:43 -0400
Message-ID: <4FB7E287.1010907@zytor.com>
Date: Sat, 19 May 2012 11:12:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Josh Boyer <jwboyer@gmail.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: Urgent: x86-32 and GNU ld 2.22.52.0.1
References: <4FB67146.9080804@zytor.com> <CAMe9rOqp5AUNL7Oeb2fz=nFq6Z-=hdFg_T2kc+jwkYtzOKJv9g@mail.gmail.com> <4FB676E0.9070206@zytor.com> <CA+5PVA6n5tJ4tox56ntrJ3T+KgZXnbxpYXjyc5_D9tQ7raQFHw@mail.gmail.com> <20120519102041.GA22271@gmail.com>
In-Reply-To: <20120519102041.GA22271@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2012 03:20 AM, Ingo Molnar wrote:
> 
> Relocation is rare, it typically happens with crashdump kernels.
> 

Or if you boot using EFI (fortunately EFI32 is rare), or you have a
screwed-up memory map (which is still rare but is increasingly common.)
 For a while some distros, including Fedora, had a messed-up config
which meant it was *always* relocated, but that was a configuration bug
which has since been fixed, I believe.

	-hpa


