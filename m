Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2CIJbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 04:31:21 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:50781 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2CIJbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:31:18 -0500
Message-ID: <4F59CDE5.8010400@oss.ntt.co.jp>
Date: Fri, 09 Mar 2012 18:31:17 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Don Zickus <dzickus@redhat.com>, akpm@linux-foundation.org,
        linux-tip-commits@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, mingo@elte.hu, vgoyal@redhat.com
Subject: Re: [PATCH 1/2] boot: ignore early NMIs
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com> <20120216172735.GX9751@redhat.com> <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com> <20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org> <m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com> <m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com> <m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com> <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp> <4F573E74.5040504@oss.ntt.co.jp> <m1eht31z8e.fsf@fess.ebiederm.org> <4F58495B.5080308@oss.ntt.co.jp> <m1r4x3yrsv.fsf@fess.ebiederm.org>
In-Reply-To: <m1r4x3yrsv.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 01:35 AM, Eric W. Biederman wrote:

> I am fine with your approach.  I suggest a big fat comment mentioning
> the 10 byte requirement and the register requirement.
>
> Neither one is locally obvious which makes it easy to goof when
> modifying the code.
Done.



>>> Doing something less brittle than:
>>>> extern const char early_idt_handlers[NUM_EXCEPTION_VECTORS][10];
>>> in segment.h might be a good idea as well.
Tackled that one too.

I will be replying to this email with the updated patches.

Thanks,
Fernando

