Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab2FUCiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:38:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39751 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2FUCh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:37:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120620193438.GB2248@gmail.com>
References: <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
	<CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com>
	<CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com>
	<CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com>
	<CAErSpo40SDii6PTNisAnsn6SoB7SzPUGztWAg9vaZZv+ByQsPw@mail.gmail.com>
	<CAE9FiQVDnS9n28GQrKVVTU7GiMtJZLFN1T9vmOm5oSysvMEVhQ@mail.gmail.com>
	<CAErSpo4x8+M6hGAqJR2rjGEGk2AnnZfJkmaJrJedzhnKiRf2qw@mail.gmail.com>
	<CAOPLpQchY4gMYaw-Ew5uujD9JCu==VLjQ7Z_OjrT6akTgX4+iA@mail.gmail.com>
	<CAErSpo6JWKoFcbsLnyzPGXLKssobfudjcYMvYzfEpYZ-bzCHPg@mail.gmail.com>
	<CAE9FiQWOUZhUQYc66ceG5EMWQ0uO7L3odh0+XwRsLV2Bza2ZpQ@mail.gmail.com>
	<20120620193438.GB2248@gmail.com>
Date: Wed, 20 Jun 2012 19:37:57 -0700
X-Google-Sender-Auth: ASRjb2tJWJR4OPrrOdbrySQdang
Message-ID: <CAE9FiQWUo3uffM4NCUORJXR1pdPaf0E1Sws1hwVNAibHg5_yjQ@mail.gmail.com>
Subject: Re: SNB PCI root information
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Ulrich Drepper <drepper@gmail.com>,
        jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 12:34 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> if the vendor provide _PXM, that _PXM should be right and be
>> trusted.
>>
>> if the vendor does not provide _PXM, we can have command line
>> to input it before user can get one updated BIOS from vendor.
>
> So how about an incorrect _PXM, or a slightly inefficient one?
> Why shouldn't it be possible for the user to override it?

Try to keep the code simple.

>
> I mean, if we create a parameter space that tweaks data then why
> not make it complete and allow *all* firmware data to be
> (optionally) modified, from the kernel boot line?

that pxm/node for pci device should be consistent with srat table etc,
so better solution is that BIOS keep them consistent.

If BIOS provide _PXM for pci device, the _PXM should have more chance
to be right.

Anyway if you insist that it should cover that wrong case, let me
check if it could be done simply.

Thanks

Yinghai
