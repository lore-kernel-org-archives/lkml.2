Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2FTTeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:34:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44443 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2FTTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:34:44 -0400
Date: Wed, 20 Jun 2012 21:34:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Ulrich Drepper <drepper@gmail.com>,
        jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Subject: Re: SNB PCI root information
Message-ID: <20120620193438.GB2248@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQWOUZhUQYc66ceG5EMWQ0uO7L3odh0+XwRsLV2Bza2ZpQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Wed, Jun 20, 2012 at 11:46 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> 
> > As far as I can tell, here's Yinghai's recommendation:  the 
> > user argument should not override BIOS _PXM because if the 
> > BIOS gets the _PXM wrong, the user won't be able to work 
> > around it with the argument, which will force the vendor to 
> > fix the BIOS.
> >
> > I'm not buying it.  The convention that user-supplied 
> > arguments always take precedence is useful, easy to 
> > document, and matches user expectations.  It allows the user 
> > to work around both missing _PXM and incorrect _PXM.
> 
> if the vendor provide _PXM, that _PXM should be right and be 
> trusted.
> 
> if the vendor does not provide _PXM, we can have command line 
> to input it before user can get one updated BIOS from vendor.

So how about an incorrect _PXM, or a slightly inefficient one? 
Why shouldn't it be possible for the user to override it?

I mean, if we create a parameter space that tweaks data then why 
not make it complete and allow *all* firmware data to be 
(optionally) modified, from the kernel boot line?

Thanks,

	Ingo
