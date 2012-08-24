Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2HXL5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:57:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55281 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2HXL5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:57:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ7jCmnXULdBHKPpqzd7aFF3D8QHF=KJ0pHpmgMPFZLdTUiKOA@mail.gmail.com>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
	<201208231814.21168.tweek@tweek.dk>
	<CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
	<CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com>
	<CAJ7jCmntV8kTup0=yLEmaGLP_vUDk4or3=UTWzODREO-pH8YxQ@mail.gmail.com>
	<CAMzpN2h8XCmEh2Xsw07_aYsW5yv87BmXNk-e6sb6gUg3eptoJw@mail.gmail.com>
	<CAJ7jCmkxS4Bor+XXvhh0Mpx5ZNyL8j8kED9KpbgMFJXED1ZoLw@mail.gmail.com>
	<CAMzpN2hfYzNwRR8o7Kz0qsuAo6JP1iSA91x=-DJP1tBz-smgTw@mail.gmail.com>
	<CAJ7jCmkNUttzRJj9bvLiuKJyZWh7UYzhA25f4kwitoHWjwhAqA@mail.gmail.com>
	<CAGa+R31cVDY9RHxyrYm-2HEDZSdMMZHcRvfZ88A9J-X9W5Hnmw@mail.gmail.com>
	<CAJ7jCmmLV1U0=zppoB8gfeh4f2KBmbcUR0GdvQ4AuHMHOMesMw@mail.gmail.com>
	<CAGa+R31TLGHDcJsG55jR8ofNDCFg7H+3+KYWaDXMJwPDZbn-6w@mail.gmail.com>
	<CAJ7jCmnXULdBHKPpqzd7aFF3D8QHF=KJ0pHpmgMPFZLdTUiKOA@mail.gmail.com>
Date: Fri, 24 Aug 2012 07:57:31 -0400
Message-ID: <CAMzpN2iQ=ff4V0wrhSJ0PmbeEKzg12UwXUB6RtbvhzAFohyehA@mail.gmail.com>
Subject: Re: Drop support for x86-32
From: Brian Gerst <brgerst@gmail.com>
To: wbrana <wbrana@gmail.com>
Cc: Ronnie Collinson <notthinking@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 6:42 AM, wbrana <wbrana@gmail.com> wrote:
> On 8/24/12, Ronnie Collinson <notthinking@gmail.com> wrote:
>> Hes just told you what x32 is, if you dont understand that, you cant
>> understand why its not a replacement for x32_64
> I know what is x32. x32 is replacement for x86-32, not x86-64.

Since you can't seem to do your homework:

https://sites.google.com/site/x32abi/documents/x32-abi-1.0.pdf?attredirects=0&d=1

Chapter 10
ILP32 Programming Model
"x32" is commonly used to refer to AMD64 ILP32 programming model.

10.2 Address Space
ILP32 binaries reside in the lower 32 bits of the 64-bit virtual
address space and
all addresses are 32 bits in size. They should conform to small code model or
small position independent code model (PIC) described in Section 3.5.1.

10.5 Coding Examples
Although ILP32 binaries run in the 64-bit mode...

--
Brian Gerst
