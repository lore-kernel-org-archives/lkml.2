Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab0KKIpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 03:45:11 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55814 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab0KKIpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 03:45:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=T8noHZN6JhX3l1LUfZWLYdYCTdTDNN9tFqapw3WWocvk1jhcDOvMPEgCDiV3BiHtM6
         KvY98ky+zP6pnpFvx0ucMtONNUnsXRHeLapVww/RsLmRBVMKqjmyoZ7lcgUcGySCizkF
         9O+HqSt7S3PheFtD+zjFgPvlzqD2dQ3Vi+uvA=
MIME-Version: 1.0
In-Reply-To: <AANLkTin=X_cc0ZpohWWOynhXGBv5Mw-9DcSjFWtRskKB@mail.gmail.com>
References: <20101110192053.GA6978@lenovo>
	<AANLkTin=X_cc0ZpohWWOynhXGBv5Mw-9DcSjFWtRskKB@mail.gmail.com>
Date: Thu, 11 Nov 2010 11:38:35 +0300
Message-ID: <AANLkTinj_Ft-nxqSQ=3JA_7oxSrLk4HSuXA6Y2oyjYNh@mail.gmail.com>
Subject: Re: [RFC -tip] x86, apic: Merge x2apic code
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Lin Ming <lin@ming.vg>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/10, Lin Ming <lin@ming.vg> wrote:
> On Thu, Nov 11, 2010 at 3:20 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>  Hi, while being at x2apic_x.c code I noted that files look similar to
>> each other so I guessed may be we could merge them. As result --
>> this patch.
>>
>>  Note that patch was only _compile_ tested, I don't have such apic for
>> real. I've trying to make it carefully but more reviews are needed,
>> I definitely might miss something.
>
> Hi, Cyrill
>
> I just give it a try on Nehalem-EX machine with x2apic.
> It boots fine.
>
> Lin Ming
>
hi Ming, thanks a huge! could you please give a try to physical mode
as well, ie with x2apic_phys boot param (if you have time of course.
:)
