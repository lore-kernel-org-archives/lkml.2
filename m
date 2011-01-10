Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab1AJHBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 02:01:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:63038 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1AJHBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 02:01:23 -0500
Message-ID: <4D2AAE4D.7030809@kernel.org>
Date: Sun, 09 Jan 2011 22:59:25 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] memblock: Don't adjust size in memblock_find_base()
References: <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com>	 <alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com>	 <4D1BD928.50701@zytor.com>	 <alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com>	 <4D1BE615.4000700@zytor.com> <20101230090648.GB7306@elte.hu>	 <20101230102815.GA29822@elte.hu> <20101230103002.GA30020@elte.hu>	 <AANLkTimeqrLzDuqBoSvmkSJWMc7u3PeRf37vjzBca2Lh@mail.gmail.com>	 <AANLkTimpyRXS9dNFATh4GqtA46uynutAvK7Qb5S7WPFO@mail.gmail.com>	 <20110105134434.GA22816@elte.hu>  <4D277A8C.5010502@kernel.org> <1294638989.17779.296.camel@pasglop>
In-Reply-To: <1294638989.17779.296.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2011 09:56 PM, Benjamin Herrenschmidt wrote:
> On Fri, 2011-01-07 at 12:41 -0800, Yinghai Lu wrote:
>> While applying patch to use memblock to find aperture for 64bit x86.
>> Ingo found system with 1g + force_iommu
> 
> Please run that through DaveM. I seem to remember that he relies on the
> size alignment to ensure that a lot of tiny allocations get properly
> coalesced or he runs out of regions at boot time.

should be safe, the path that DaveM need, still have those size alignment applied.

Thanks

Yinghai
