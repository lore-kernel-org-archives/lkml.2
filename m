Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1BBJZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 04:25:38 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35086 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1BBJZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 04:25:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=lPZiXCwpSoSBjzJopWRTK2Xaomn76m8OUbxTkx9Jk86X7r49yhdkKaSwdBiRDlO2di
         2PfuYNM7mTJYhJSGrW3qj4caTruhNwR6/vWfV1YeXkYQfSxxYKYc1b/aGN5oyidQZvcn
         m2JKzndPHL068yJLsjuH6COueLI9RDyZRmQ3s=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D491F94.6070803@redhat.com>
References: <1294009289-28802-1-git-send-email-sedat.dilek@gmail.com>
	<20110104210307.GB6130@amt.cnet>
	<AANLkTi=V6PvG42bBmE=7qcm=5vvk=SeUJ6a8oMKOcihb@mail.gmail.com>
	<4D491F94.6070803@redhat.com>
Date: Wed, 2 Feb 2011 10:25:35 +0100
Message-ID: <AANLkTi=zLfxwb1qYNn1kzZoGpTe5NNAtuY1oAr7EDuPG@mail.gmail.com>
Subject: Re: [PATCH] kvm: Fix section mismatch derived from kvm_guest_cpu_online()
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, riel@redhat.com,
        gleb@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 10:10 AM, Avi Kivity <avi@redhat.com> wrote:
> On 02/02/2011 09:55 AM, Sedat Dilek wrote:
>>
>> On Tue, Jan 4, 2011 at 10:03 PM, Marcelo Tosatti<mtosatti@redhat.com>
>>  wrote:
>> >  On Mon, Jan 03, 2011 at 12:01:29AM +0100, Sedat Dilek wrote:
>> >>  > From my build.log:
>> >>
>> >>  WARNING: arch/x86/built-in.o(.text+0x1bb74): Section mismatch in
>> >> reference from the function kvm_guest_cpu_online() to the function
>> >> .cpuinit.text:kvm_guest_cpu_init()
>> >>  The function kvm_guest_cpu_online() references
>> >>  the function __cpuinit kvm_guest_cpu_init().
>> >>  This is often because kvm_guest_cpu_online lacks a __cpuinit
>> >>  annotation or the annotation of kvm_guest_cpu_init is wrong.
>> >>
>> >>  This patch fixes the warning.
>> >>
>> >>  Tested with linux-next (next-20101231)
>> >>
>> >>  Signed-off-by: Sedat Dilek<sedat.dilek@gmail.com>
>> >
>> >  Applied, thanks.
>> >
>> >
>>
>> PING!
>>
>> Was this patch really applied? I have it still in my patch-series.
>>
>
> It was applied to kvm.git and will find its way upstream eventually.
>

OK, I found it [1] in next GIT branch [2] and I guess this branch is
not pulled into linux-next.
Thanks for the pointer.

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/avi/kvm.git;a=commit;h=ca905a6071b3daca83a91ae43106c40bd85e8a3d
[2] http://git.kernel.org/?p=linux/kernel/git/avi/kvm.git;a=shortlog;h=refs/heads/next
