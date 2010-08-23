Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab0HWOzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:55:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55648 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab0HWOzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:55:07 -0400
X-User-Agent: K-9 Mail for Android
References: <20100819224616.GB9967@router-fw-old.local.net-space.pl> <tip-05e407603e527f9d808dd3866d3a17c2ce4dfcc5@git.kernel.org> <AANLkTim9kjBp68LqieU3MDLbkRDiWLNQjtUvjEbc9Hca@mail.gmail.com> <20100823081212.GA13297@router-fw-old.local.net-space.pl>
In-Reply-To: <20100823081212.GA13297@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/urgent] x86, apic: Fix apic=debug boot crash
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 23 Aug 2010 07:54:34 -0700
To: Daniel Kiper <dkiper@net-space.pl>, Yinghai Lu <yinghai@kernel.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Message-ID: <9cca0990-1b78-40e7-a71d-f550b4f504aa@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's already applied.

"Daniel Kiper" <dkiper@net-space.pl> wrote:

>Hi,
>
>On Fri, Aug 20, 2010 at 12:24:20PM -0700, Yinghai Lu wrote:
>> On Fri, Aug 20, 2010 at 5:41 AM, tip-bot for Daniel Kiper
>> <dkiper@net-space.pl> wrote:
>> > Commit-ID: ?05e407603e527f9d808dd3866d3a17c2ce4dfcc5
>> > Gitweb: ? ? http://git.kernel.org/tip/05e407603e527f9d808dd3866d3a17c2ce4dfcc5
>> > Author: ? ? Daniel Kiper <dkiper@net-space.pl>
>> > AuthorDate: Fri, 20 Aug 2010 00:46:16 +0200
>> > Committer: ?Ingo Molnar <mingo@elte.hu>
>> > CommitDate: Fri, 20 Aug 2010 10:18:28 +0200
>> >
>> > x86, apic: Fix apic=debug boot crash
>> >
>> > Fix a boot crash when apic=debug is used and the APIC is
>> > not properly initialized.
>> >
>> > This issue appears during Xen Dom0 kernel boot but the
>> > fix is generic and the crash could occur on real hardware
>> > as well.
>>
>> Do you have any report on real hardware?
>> that could not happen on real hardware.
>
>Till now no, however I think it is good idea
>to apply this patch now. It is not worth to wait
>for another null pointer dereference.
>
>Daniel

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
