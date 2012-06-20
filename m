Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab2FTVWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 17:22:15 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37638 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab2FTVWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 17:22:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6AyMqWXU6+jGVEqno-qbjAUmrpcc7=hN-Yo5YCfCvCCg@mail.gmail.com>
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
 <20120620193438.GB2248@gmail.com> <CAOPLpQdi-8NZL1rwt3APU_is4GcyGaAN0Vq0T23BMSHob--YYg@mail.gmail.com>
 <CAErSpo6AyMqWXU6+jGVEqno-qbjAUmrpcc7=hN-Yo5YCfCvCCg@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 20 Jun 2012 17:21:51 -0400
Message-ID: <CAOPLpQfRSOm4mYFciDky9XqZdb+7nG29ZxR0CpVFzNsnPiPO7w@mail.gmail.com>
Subject: Re: SNB PCI root information
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 4:16 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> It's not a question of "do BIOSes get this wrong?"  The question is
> "what does a user expect to happen when she supplies
> 'pci=busnum_node=00:00,80:01'?"  I contend that the user expects us to
> use that info whether the BIOS gave us correct info, wrong info, or
> nothing at all.

Think about busnum_node as busnum_default_node.  Then the behavior
makes perfect sense.

I contend that the really the only reason for overwriting is if there
are wrong BIOS.
