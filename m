Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab2FUF43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 01:56:29 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:6438 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755344Ab2FUF41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 01:56:27 -0400
X-IronPort-AV: E=Sophos;i="4.77,449,1336341600"; 
   d="scan'208";a="148307572"
Message-ID: <4FE2B788.3070505@gmail.com>
Date: Thu, 21 Jun 2012 07:56:24 +0200
From: Brice Goglin <brice.goglin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Ulrich Drepper <drepper@gmail.com>,
        jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Subject: Re: SNB PCI root information
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com> <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com> <CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com> <CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com> <CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com> <CAErSpo40SDii6PTNisAnsn6SoB7SzPUGztWAg9vaZZv+ByQsPw@mail.gmail.com> <CAE9FiQVDnS9n28GQrKVVTU7GiMtJZLFN1T9vmOm5oSysvMEVhQ@mail.gmail.com> <CAErSpo4x8+M6hGAqJR2rjGEGk2AnnZfJkmaJrJedzhnKiRf2qw@mail.gmail.com> <CAOPLpQchY4gMYaw-Ew5uujD9JCu==VLjQ7Z_OjrT6akTgX4+iA@mail.gmail.com> <CAErSpo6JWKoFcbsLnyzPGXLKssobfudjcYMvYzfEpYZ-bzCHPg@mail.gmail.com> <CAE9FiQWOUZhUQYc66ceG5EMWQ0uO7L3odh0+XwRsLV2Bza2ZpQ@mail.gmail.com> <4FE22B28.9020402@gmail.com> <CAE9FiQUkGCQ0Y=n3i=bq388T8N-vrHP2LtMTFGwry2nA+uppwA@mail.gmail.com>
In-Reply-To: <CAE9FiQUkGCQ0Y=n3i=bq388T8N-vrHP2LtMTFGwry2nA+uppwA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 21/06/2012 04:43, Yinghai Lu a écrit :
> On Wed, Jun 20, 2012 at 12:57 PM, Brice Goglin <brice.goglin@gmail.com> wrote:
>> Le 20/06/2012 21:28, Yinghai Lu a écrit :
>>> On Wed, Jun 20, 2012 at 11:46 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> I agree that the most common problem is that _PXM is missing. But I've
>> seen at least some HP Westmere-EP platforms where _PXM exists but it is
>> wrong. Last time we checked, there was no BIOS update, even if we
>> reported the bug a while ago.
>>
> Do you have boot log or acpi dump?
>
> I suspected that could be other problem. intel system before
> sandbridge does not have IIO.
> they will have ioh instead, and one ioh would connect to two cpu sockets.
> but _PXM for root bus in dsdt only can return one value. Aka it is
> acpi spec limitation.

The machines I am talking about have two IOHs (one connected to each
socket). I only have an old 2.6.27 boot log at hand, I'll ask my admins
for more. Do you want the 2.6.27 dmesg anyway?

Brice

