Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab1HOAcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 20:32:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47674 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1HOAcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 20:32:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110815001841.GW5782@one.firstfloor.org>
References: <20110812150304.GC16880@albatros>
	<4E45884B.8030303@zytor.com>
	<20110813062246.GC3851@albatros>
	<36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com>
	<m2ei0olnua.fsf@firstfloor.org>
	<632d03b0-6725-431e-b100-13f5046b03e9@email.android.com>
	<20110814092028.GB14293@openwall.com>
	<01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com>
	<20110814152729.GU5782@one.firstfloor.org>
	<4E47EB99.1020909@zytor.com>
	<20110815001841.GW5782@one.firstfloor.org>
Date: Sun, 14 Aug 2011 19:32:16 -0500
Message-ID: <CABqD9hYtu8RJC3H263Smej7zWASDjO6C82QdFxZ6q-KiQCdJZg@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32
 or 64 bit syscalls
From: Will Drewry <wad@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Solar Designer <solar@openwall.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        James Morris <jmorris@namei.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 7:18 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Sun, Aug 14, 2011 at 08:36:57AM -0700, H. Peter Anvin wrote:
>> On 08/14/2011 08:27 AM, Andi Kleen wrote:
>> >> i386 vs x86-64 vs x32 is just one of many axes along which syscalls can be restricted (and for that matter, one axis if backward compatibility), and it does not make sense to burden the code with ad hoc filters.  Designing a general filter facility which can be used to restrict any container to the subset of system calls it actually needs would make more sense, no?
>> >
>> > I believe this is already in the newer versions of seccomp.
>> >
>>
>> Last I looked seccomp still had a hardcoded list of system calls, but
>> perhaps I've been looking in the wrong place.  However, since that's
>> exactly what seccomp is -- a system call filter -- this can, and should,
>> be unified that way.
>
> True. I guess I confused the endless l-k threads with actual code.
>
> I guess the code was too expensive for the talk back then @)

Perhaps :) I wish it had landed after 9 revisions and at least two
variant patches. Despite that, I think it's great to pull in
additional requirements, like COMPAT locking, to make sure that the
solution is really a good one.  It may also be that my entire original
approach was wrong and should be revisited too.  Everyone's comments
here and the proposed patch itself certainly have me thinking.

cheers!
will
