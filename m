Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab0IVFmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 01:42:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:36873 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab0IVFmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 01:42:01 -0400
Subject: Re: [PATCH] fsldma: add support to 36-bit physical address
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <AANLkTinbjb+uQdby999rs1eF1sqPHY2vXJ1mVrznFv=0@mail.gmail.com>
Date: Wed, 22 Sep 2010 00:41:43 -0500
Cc: Scott Wood <scottwood@freescale.com>, Dan Malek <ppc6dev@digitaldans.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Becky Bruce <beckyb@kernel.crashing.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <492E9153-2D3E-4DA2-AD04-4F92C94DB3A7@kernel.crashing.org>
References: <1285066638-7473-1-git-send-email-leoli@freescale.com> <877FD0B5-19A7-4A16-831E-369B80B104EA@kernel.crashing.org> <AANLkTimiwtoa6i10OTcgFnvbvcO9N4KWHyt4Poj-yj=T@mail.gmail.com> <20100921163456.7e2c9b32@udp111988uds.am.freescale.net> <AANLkTine--kry0c0n87WOqYyi3AQOb2KnmNRs-MeXcQt@mail.gmail.com> <20100921164944.164ed0af@udp111988uds.am.freescale.net> <2C3F2C02-35B6-46AF-82DA-44ACCBFB8362@digitaldans.com> <AANLkTinKbBBbC1gmPewhn1f3MW-1MbARtiQZNX4w7Mi+@mail.gmail.com> <20100921171746.381f2e89@udp111988uds.am.freescale.net> <AANLkTinbjb+uQdby999rs1eF1sqPHY2vXJ1mVrznFv=0@mail.gmail.com>
To: Timur Tabi <timur.tabi@gmail.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 21, 2010, at 5:34 PM, Timur Tabi wrote:

> On Tue, Sep 21, 2010 at 5:17 PM, Scott Wood <scottwood@freescale.com> wrote:
> 
>> It needs to be the actual device that is performing the DMA -- the
>> platform may need to do things such as IOMMU manipulation where
>> knowing the device matters.
> 
> Ok, this all makes sense.  So it appears that the patch is valid, at
> least in theory.  I would like to see some testing of it, but I
> realize that may be too difficult.  There's no easy way to force an
> allocation above 4GB.

I think the patch is pretty safe w/o testing.  However I agree we need a better solution to testing 36-bit addressing.

- k