Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab2AHOo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 09:44:28 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62426 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2AHOo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 09:44:26 -0500
MIME-Version: 1.0
In-Reply-To: <4F09A344.8020000@redhat.com>
References: <1325967346-12539-1-git-send-email-namit@cs.technion.ac.il>
	<E0EE2EE9-96C1-4354-BDCE-19E3AF2C0F30@gmail.com>
	<4F08AA3C.9090306@zytor.com>
	<C814BCA3-145A-410F-8F4F-CE5617DDB1A2@gmail.com>
	<20120108102657.9a5dd6534ea4ae829073ff6e@gmail.com>
	<CAKLkAJ4=eT7TdZoOkQKMnhmrESq5kvCQL3Mw52a35gu2yWsNgw@mail.gmail.com>
	<4F09A2A0.1060801@redhat.com>
	<4F09A344.8020000@redhat.com>
Date: Sun, 8 Jan 2012 16:44:25 +0200
Message-ID: <CAKLkAJ7JTW0ptNCPdBdWbCP9rt-w5=5nbJmEo+8wm0-nnjWhzw@mail.gmail.com>
Subject: Re: [PATCH] KVM: fix mov immediate emulation for 64-bit operands
From: Nadav Amit <nadav.amit@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 4:08 PM, Avi Kivity <avi@redhat.com> wrote:
> On 01/08/2012 04:05 PM, Avi Kivity wrote:
>> >
>> > Avi, please acknowledge adding OpImm64.
>>
>> Yes, OpImm64 is the cleanest IMO.  Note it doesn't even cost us a bit.

Very well - I'll submit a revised patch later.

>
> Note, usually I'd ask for a unit test to accompany the fix, but the
> current framework only supports testing instructions that have a memroy
> operand.  So you're off the hook for now, unless you'd like to extend
> the framework.

Unfortunately, I don't. I am doing some odd things with KVM that cause
me to encounter emulator bugs.
I am likely to submit another patch or two as the emulation code has
additional "issues" handling EPT violations (especially on non-memory
operands).

Regards,
Nadav
