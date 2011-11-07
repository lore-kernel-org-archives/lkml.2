Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab1KGIVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 03:21:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab1KGIVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 03:21:14 -0500
Message-ID: <4EB794E1.5060201@redhat.com>
Date: Mon, 07 Nov 2011 09:20:49 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Alexander Graf <agraf@suse.de>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Blue Swirl <blauwirbel@gmail.com>, Avi Kivity <avi@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de> <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com> <4EB6DBC6.2010404@redhat.com> <CAOJsxLGzMqQDwfm8C-6g8SCapEmGs7uUPq+SuL946yg=anV85g@mail.gmail.com> <4EB6E798.3060000@redhat.com> <CAOJsxLF6bOPJk+atASGr_Ra3BfwbkGPfGb2iRCOrfpFODBc-jA@mail.gmail.com> <4EB79000.5040308@redhat.com> <CAOJsxLHhfD7WoY8AgwcpQdOFn71N8ta+fNxsg_49cCNXG9GPrw@mail.gmail.com>
In-Reply-To: <CAOJsxLHhfD7WoY8AgwcpQdOFn71N8ta+fNxsg_49cCNXG9GPrw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 09:09 AM, Pekka Enberg wrote:
> We are obviously also using specifications but as you damn well should
> know, specifications don't matter nearly as much as working code.

Specifications matter much more than working code.  Quirks are a fact of 
life but should always come second.

To bring you an example from the kernel, there is a very boring list of 
"PCI quirks" and a lot of code for "PCI specs", not the other way round.

Paolo
