Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab2FTT2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:28:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56927 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab2FTT2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:28:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6JWKoFcbsLnyzPGXLKssobfudjcYMvYzfEpYZ-bzCHPg@mail.gmail.com>
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
Date: Wed, 20 Jun 2012 12:28:12 -0700
X-Google-Sender-Auth: qT4aS6cUrJVUrme3vdS-oSiyUzk
Message-ID: <CAE9FiQWOUZhUQYc66ceG5EMWQ0uO7L3odh0+XwRsLV2Bza2ZpQ@mail.gmail.com>
Subject: Re: SNB PCI root information
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ulrich Drepper <drepper@gmail.com>, jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 11:46 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:

> As far as I can tell, here's Yinghai's recommendation:  the user
> argument should not override BIOS _PXM because if the BIOS gets the
> _PXM wrong, the user won't be able to work around it with the
> argument, which will force the vendor to fix the BIOS.
>
> I'm not buying it.  The convention that user-supplied arguments always
> take precedence is useful, easy to document, and matches user
> expectations.  It allows the user to work around both missing _PXM and
> incorrect _PXM.

if the vendor provide _PXM, that _PXM should be right and be trusted.

if the vendor does not provide _PXM, we can have command line to input
it before user can get one updated BIOS from vendor.

Yinghai
