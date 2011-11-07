Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab1KGIpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 03:45:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53402 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1KGIpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 03:45:35 -0500
Date: Mon, 7 Nov 2011 10:45:22 +0200 (EET)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@tux.localdomain
To: Paolo Bonzini <pbonzini@redhat.com>
cc: Pekka Enberg <penberg@kernel.org>, Alexander Graf <agraf@suse.de>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Blue Swirl <blauwirbel@gmail.com>, Avi Kivity <avi@redhat.com>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
In-Reply-To: <4EB794E1.5060201@redhat.com>
Message-ID: <alpine.LFD.2.02.1111071038250.6486@tux.localdomain>
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com>
 <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
 <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de> <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com> <4EB6DBC6.2010404@redhat.com> <CAOJsxLGzMqQDwfm8C-6g8SCapEmGs7uUPq+SuL946yg=anV85g@mail.gmail.com> <4EB6E798.3060000@redhat.com>
 <CAOJsxLF6bOPJk+atASGr_Ra3BfwbkGPfGb2iRCOrfpFODBc-jA@mail.gmail.com> <4EB79000.5040308@redhat.com> <CAOJsxLHhfD7WoY8AgwcpQdOFn71N8ta+fNxsg_49cCNXG9GPrw@mail.gmail.com> <4EB794E1.5060201@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2082177677-1320655531=:6486"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2082177677-1320655531=:6486
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On 11/07/2011 09:09 AM, Pekka Enberg wrote:
>> We are obviously also using specifications but as you damn well should
>> know, specifications don't matter nearly as much as working code.

On Mon, 7 Nov 2011, Paolo Bonzini wrote:
> Specifications matter much more than working code.  Quirks are a fact of life 
> but should always come second.

To quote Linus:

   And I have seen _lots_ of total crap work that was based on specs. It's
   _the_ single worst way to write software, because it by definition means
   that the software was written to match theory, not reality.

[ http://kerneltrap.org/node/5725 ]

So no, I don't agree with you at all.

 			Pekka
--8323328-2082177677-1320655531=:6486--
