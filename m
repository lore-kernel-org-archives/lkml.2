Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab2FUCnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:43:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51004 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab2FUCnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:43:22 -0400
MIME-Version: 1.0
In-Reply-To: <4FE22B28.9020402@gmail.com>
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com>
	<CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
	<CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com>
	<CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com>
	<CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com>
	<CAErSpo40SDii6PTNisAnsn6SoB7SzPUGztWAg9vaZZv+ByQsPw@mail.gmail.com>
	<CAE9FiQVDnS9n28GQrKVVTU7GiMtJZLFN1T9vmOm5oSysvMEVhQ@mail.gmail.com>
	<CAErSpo4x8+M6hGAqJR2rjGEGk2AnnZfJkmaJrJedzhnKiRf2qw@mail.gmail.com>
	<CAOPLpQchY4gMYaw-Ew5uujD9JCu==VLjQ7Z_OjrT6akTgX4+iA@mail.gmail.com>
	<CAErSpo6JWKoFcbsLnyzPGXLKssobfudjcYMvYzfEpYZ-bzCHPg@mail.gmail.com>
	<CAE9FiQWOUZhUQYc66ceG5EMWQ0uO7L3odh0+XwRsLV2Bza2ZpQ@mail.gmail.com>
	<4FE22B28.9020402@gmail.com>
Date: Wed, 20 Jun 2012 19:43:22 -0700
X-Google-Sender-Auth: -IN6A5cI19rsDw1JGTNs_x_g5u8
Message-ID: <CAE9FiQUkGCQ0Y=n3i=bq388T8N-vrHP2LtMTFGwry2nA+uppwA@mail.gmail.com>
Subject: Re: SNB PCI root information
From: Yinghai Lu <yinghai@kernel.org>
To: Brice Goglin <brice.goglin@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Ulrich Drepper <drepper@gmail.com>,
        jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 12:57 PM, Brice Goglin <brice.goglin@gmail.com> wrote:
> Le 20/06/2012 21:28, Yinghai Lu a écrit :
>> On Wed, Jun 20, 2012 at 11:46 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> I agree that the most common problem is that _PXM is missing. But I've
> seen at least some HP Westmere-EP platforms where _PXM exists but it is
> wrong. Last time we checked, there was no BIOS update, even if we
> reported the bug a while ago.
>
Do you have boot log or acpi dump?

I suspected that could be other problem. intel system before
sandbridge does not have IIO.
they will have ioh instead, and one ioh would connect to two cpu sockets.
but _PXM for root bus in dsdt only can return one value. Aka it is
acpi spec limitation.

for example, Sun x4800 8 sockets server would have bus 00, 40, 80, c0.
but _PXM will only return 0, 2, 3, 6.

Thanks

Yinghai
