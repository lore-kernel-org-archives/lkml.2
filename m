Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0GFXkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 19:40:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48779 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab0GFXkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 19:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dKZuTvRCEscqat3ENSylh9cIX3wvvQWcd3kOoSEwNGspKiUZuXvOtOHnhlgifWrFI9
         hJh7pWNC7mqmmflhRliIpb0kbxuglOfIgUodtfeJWZR1Z9tkQPd0qA3Y9BoxHfqcoFD4
         DmrcPn4twENcelTWuMFe9ud32coiv2MpAa+48=
MIME-Version: 1.0
In-Reply-To: <1278324973.16975.68.camel@localhost>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	<4C29420D.2010406@intel.com>
	<AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	<4C2A8879.8010000@intel.com>
	<AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	<4C2AC55E.3040303@intel.com>
	<AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	<1277923422.16256.8.camel@localhost>
	<4C2B9DAC.1030806@intel.com>
	<1277928125.18854.0.camel@localhost>
	<4C2BBACF.3080405@intel.com>
	<1277965264.18854.16.camel@localhost>
	<4C2C3B07.7050200@intel.com>
	<1277968336.4945.3.camel@localhost>
	<4C2C4319.6090906@intel.com>
	<1277972137.12558.2.camel@localhost>
	<4C2CCE67.6070600@intel.com>
	<AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>
	<AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>
	<1278324973.16975.68.camel@localhost>
Date: Tue, 6 Jul 2010 16:40:21 -0700
X-Google-Sender-Auth: KHKEONWo15pcHI70YRrUxTxhp4w
Message-ID: <AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: Chris Li <lkml@chrisli.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 5, 2010 at 3:16 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Fri, 2010-07-02 at 20:00 +0100, Chris Li wrote:
>> But I don't see the line that print out BIOS is lying.
>
> Hrm. Want to augment the dmar_find_matched_drhd_unit() function to
> _always_ print the DRHD returned for the offending PCI device? And if
> that still doesn't show, make it print pdev->vendor, pdev->device and
> the returned DRHD pointer for _every_ call?

I just did some experiment, my PCI device ID is  PCI_DEVICE_ID_INTEL_ESB2_0
(0x2670) instead of PCI_DEVICE_ID_INTEL_IOAT_SNB.

That seems to be the reason preventing the warning to be print out. I am not
sure the warning should be always print out. Just curious why it did
not trigger.

Chris
