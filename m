Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2FVR27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:28:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40910 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab2FVR25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:28:57 -0400
MIME-Version: 1.0
In-Reply-To: <4FE41B3E.7080609@gmail.com>
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
	<CAE9FiQWBB0JVCLWa40k9qYJXGrv_z=RgspgQW4x2di0uCUFXmA@mail.gmail.com>
	<4FE41B3E.7080609@gmail.com>
Date: Fri, 22 Jun 2012 10:28:56 -0700
X-Google-Sender-Auth: VRO8E_ZYJ0JIvCW3J3B4b4-UbA4
Message-ID: <CAE9FiQWB-=qRQfJS=95a+L_N32bZ97MCdW3voDCNSCbVcCnERQ@mail.gmail.com>
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

On Fri, Jun 22, 2012 at 12:14 AM, Brice Goglin <brice.goglin@gmail.com> wrote:

>> BIOS _PXM return 0 for both pci root buses?
>>
>
> Here's dmesg.
> I can't say for sure whether _PXM returns 0 since I don't know how to
> read all this :) But Linux puts the first socket cpumap in
> /sys/bus/pci/devices/*/local_cpus (and that's wrong according to the
> motherboard manual and according to the performance we see).
>

hi, looks like you system bios does not provide _PXM for the root bus.

Thanks

Yinghai
