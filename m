Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122Ab2FUTYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:24:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41508 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab2FUTYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:24:08 -0400
MIME-Version: 1.0
In-Reply-To: <4FE2B788.3070505@gmail.com>
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
	<CAE9FiQUkGCQ0Y=n3i=bq388T8N-vrHP2LtMTFGwry2nA+uppwA@mail.gmail.com>
	<4FE2B788.3070505@gmail.com>
Date: Thu, 21 Jun 2012 12:24:07 -0700
X-Google-Sender-Auth: 2XkXm_9GenssjPdtkWHpUyYsh5g
Message-ID: <CAE9FiQWBB0JVCLWa40k9qYJXGrv_z=RgspgQW4x2di0uCUFXmA@mail.gmail.com>
Subject: Re: SNB PCI root information
From: Yinghai Lu <yinghai@kernel.org>
To: Brice Goglin <brice.goglin@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Ulrich Drepper <drepper@gmail.com>,
        jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 10:56 PM, Brice Goglin <brice.goglin@gmail.com> wrote:
>> I suspected that could be other problem. intel system before
>> sandbridge does not have IIO.
>> they will have ioh instead, and one ioh would connect to two cpu sockets.
>> but _PXM for root bus in dsdt only can return one value. Aka it is
>> acpi spec limitation.
>
> The machines I am talking about have two IOHs (one connected to each
> socket). I only have an old 2.6.27 boot log at hand, I'll ask my admins
> for more. Do you want the 2.6.27 dmesg anyway?
>

log from 2.6.27 should be good enough for this.

BIOS _PXM return 0 for both pci root buses?

those systems with two IOHs really deserve good BIOS.

Hope we can have more updated machines with open sourced firmware.

Thanks

Yinghai
