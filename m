Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab0IWWMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:12:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33256 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab0IWWL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nqFry1mUg5zRISjpHQzr+d2HpmLjaZgErjBwfC6kja43LPV7VMvaDyMXqz+GZU/S08
         itHpY0CLExVn6LgjZhWuXkzD8Nyf47V9OAYX3aEphiC8+uIJeLWSnoomAO1h4o4UQpTn
         rOj8BVKuKFS07bH63LnM/EKXlkKoWDmkQixkM=
MIME-Version: 1.0
In-Reply-To: <492E9153-2D3E-4DA2-AD04-4F92C94DB3A7@kernel.crashing.org>
References: <1285066638-7473-1-git-send-email-leoli@freescale.com>
	<877FD0B5-19A7-4A16-831E-369B80B104EA@kernel.crashing.org>
	<AANLkTimiwtoa6i10OTcgFnvbvcO9N4KWHyt4Poj-yj=T@mail.gmail.com>
	<20100921163456.7e2c9b32@udp111988uds.am.freescale.net>
	<AANLkTine--kry0c0n87WOqYyi3AQOb2KnmNRs-MeXcQt@mail.gmail.com>
	<20100921164944.164ed0af@udp111988uds.am.freescale.net>
	<2C3F2C02-35B6-46AF-82DA-44ACCBFB8362@digitaldans.com>
	<AANLkTinKbBBbC1gmPewhn1f3MW-1MbARtiQZNX4w7Mi+@mail.gmail.com>
	<20100921171746.381f2e89@udp111988uds.am.freescale.net>
	<AANLkTinbjb+uQdby999rs1eF1sqPHY2vXJ1mVrznFv=0@mail.gmail.com>
	<492E9153-2D3E-4DA2-AD04-4F92C94DB3A7@kernel.crashing.org>
Date: Thu, 23 Sep 2010 15:11:57 -0700
X-Google-Sender-Auth: jzuUGpwZdGkBEojyWz1QfgAaEmg
Message-ID: <AANLkTinfHQGqWx2txwG4-nORcwcFD9dYstmVv8iK9oZ8@mail.gmail.com>
Subject: Re: [PATCH] fsldma: add support to 36-bit physical address
From: Dan Williams <dan.j.williams@intel.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Timur Tabi <timur.tabi@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Dan Malek <ppc6dev@digitaldans.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Becky Bruce <beckyb@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 10:41 PM, Kumar Gala <galak@kernel.crashing.org> wrote:
>
> On Sep 21, 2010, at 5:34 PM, Timur Tabi wrote:
>
>> On Tue, Sep 21, 2010 at 5:17 PM, Scott Wood <scottwood@freescale.com> wrote:
>>
>>> It needs to be the actual device that is performing the DMA -- the
>>> platform may need to do things such as IOMMU manipulation where
>>> knowing the device matters.
>>
>> Ok, this all makes sense.  So it appears that the patch is valid, at
>> least in theory.  I would like to see some testing of it, but I
>> realize that may be too difficult.  There's no easy way to force an
>> allocation above 4GB.
>
> I think the patch is pretty safe w/o testing.  However I agree we need a better solution to testing 36-bit addressing.

I'll take that as an acked-by, but I'll wait for the next version of
the patch with the completed changelog before acting on it.

--
Dan
