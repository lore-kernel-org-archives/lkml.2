Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2F1MMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:12:03 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60610 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2F1MMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:12:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120625171532.GB16275@sortiz-mobl>
References: <1339423241.4999.53.camel@lappy> <20120611144134.GX22557@sortiz-mobl>
 <1339425693.6001.2268.camel@edumazet-glaptop> <20120611145700.GY22557@sortiz-mobl>
 <1339426778.6001.2312.camel@edumazet-glaptop> <20120611152007.GZ22557@sortiz-mobl>
 <1339433810.4999.65.camel@lappy> <20120611172545.GA1776@redhat.com>
 <CA+1xoqcwr-5dzHvqkt9x0-xj9EFAywVfva=asbHXvX-LSBWqdA@mail.gmail.com>
 <1340639612.10893.84.camel@edumazet-glaptop> <20120625171532.GB16275@sortiz-mobl>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 28 Jun 2012 14:11:38 +0200
Message-ID: <CA+1xoqfy21wOh2myV0D6iBDqoZ3YmkwNZwKBVXLU75zePOGi4w@mail.gmail.com>
Subject: Re: [PATCH] net: nfc: fix panic in accept()
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Dave Jones <davej@redhat.com>,
        David Miller <davem@davemloft.net>, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Mon, Jun 25, 2012 at 7:15 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Eric,
>
> On Mon, Jun 25, 2012 at 05:53:32PM +0200, Eric Dumazet wrote:
>> From: Eric Dumazet <edumazet@google.com>
>>
>> Sasha Levin reported following panic :
> I applied a similar patch, more consistent with the rest of the NFC socket
> code, still with you as the author. See here:
>
> http://git.kernel.org/?p=linux/kernel/git/sameo/nfc-3.0.git;a=commit;h=631c301f20558525a641fadffc0126affd3dc4a4

Could this tree be included in -next please?
