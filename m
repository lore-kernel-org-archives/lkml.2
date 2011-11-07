Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1KGI5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 03:57:50 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40443 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1KGI5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 03:57:48 -0500
MIME-Version: 1.0
In-Reply-To: <4EB79C3E.6070606@redhat.com>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
	<4EB66036.4080102@redhat.com>
	<1320577728.1428.73.camel@jaguar>
	<4EB67486.1070105@redhat.com>
	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
	<4EB67D17.7000701@redhat.com>
	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
	<4EB680D9.2070706@redhat.com>
	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
	<877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
	<CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
	<4EB6DBC6.2010404@redhat.com>
	<CAOJsxLGzMqQDwfm8C-6g8SCapEmGs7uUPq+SuL946yg=anV85g@mail.gmail.com>
	<4EB6E798.3060000@redhat.com>
	<CAOJsxLF6bOPJk+atASGr_Ra3BfwbkGPfGb2iRCOrfpFODBc-jA@mail.gmail.com>
	<4EB79000.5040308@redhat.com>
	<CAOJsxLHhfD7WoY8AgwcpQdOFn71N8ta+fNxsg_49cCNXG9GPrw@mail.gmail.com>
	<4EB794E1.5060201@redhat.com>
	<alpine.LFD.2.02.1111071038250.6486@tux.localdomain>
	<4EB79C3E.6070606@redhat.com>
Date: Mon, 7 Nov 2011 10:57:47 +0200
X-Google-Sender-Auth: ZRUaTOmjE8OZYqP4eIpEKXjyhHw
Message-ID: <CAOJsxLEkYYoSrjjkCwiJ7MSdrUUQCf_Ewb8S6kFMBaEq5cNmQA@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Graf <agraf@suse.de>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Blue Swirl <blauwirbel@gmail.com>, Avi Kivity <avi@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 09:45 AM, Pekka Enberg wrote:
>>> Specifications matter much more than working code.  Quirks are a fact
>>> of life but should always come second.
>>
>> To quote Linus:
>>
>>   And I have seen _lots_ of total crap work that was based on specs. It's
>> _the_ single worst way to write software, because it by definition means
>>   that the software was written to match theory, not reality.

On Mon, Nov 7, 2011 at 10:52 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> All generalizations are false.

What is that supposed to mean? You claimed we're "doing it wrong" and
I explained you why we are doing it the way we are.

Really, the way we do things in the KVM tool is not a bug, it's a feature.

                        Pekka
