Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab2FUMSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:18:01 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48993 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab2FUMR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:17:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWKxe9VYvrQy5h4RP2dS7YHHXu4icjC+KPipkRKbsZN1g@mail.gmail.com>
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
 <20120620193438.GB2248@gmail.com> <CAE9FiQWUo3uffM4NCUORJXR1pdPaf0E1Sws1hwVNAibHg5_yjQ@mail.gmail.com>
 <CAE9FiQWKxe9VYvrQy5h4RP2dS7YHHXu4icjC+KPipkRKbsZN1g@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Thu, 21 Jun 2012 08:17:37 -0400
Message-ID: <CAOPLpQeOEPECiq_D7WxYMoWk0AbS8vXLJqhm1EPijGdH52TVvQ@mail.gmail.com>
Subject: Re: SNB PCI root information
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 11:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> please check -v3, and it will add 40 lines.

Won't this version print out something like

  PCI: unknown option `busnum_node=xx:yy'


I can verify but that's what I saw when the use of ',' as the
separator caused mis-parsing.

I think you have to provide an extension to pcibios_setup in any case.
