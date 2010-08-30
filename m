Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab0H3HFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:05:16 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:54189 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751392Ab0H3HFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:05:15 -0400
Message-ID: <4C7B5825.6030302@bluewatersys.com>
Date: Mon, 30 Aug 2010 19:05:09 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Wolfgang_M=FCes?= <wolfgang.mues@auerswald.de>
CC: Chris Ball <cjb@laptop.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        avictor.za@gmail.com, akpm@linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] mmc: at91_mci: fix pointer errors
References: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com> <20100827193303.GB23079@void.printf.net> <4C7AD3A0.40607@bluewatersys.com> <4C7B5601.5060505@auerswald.de>
In-Reply-To: <4C7B5601.5060505@auerswald.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Mües wrote:
> Hi,
> 
> Am 29.08.2010 23:39, schrieb Ryan Mallon:
>> I see this is already applied, but why all the type trickery here? Why
>> not just:
>>
>>     memcpy(dmabuf, sgbuffer, amount);
>>     dmabuf += amount / sizeof(dmabuf);
> 
> Because this is wrong?
> 
> Maybe you mean sizeof(*dmabuf)?

Sorry, yes.

> The exact style of the bug fix is not important, it's important that
> it's fixed.

I disagree, it's also important that it is fixed in a clear,
understandable way. I found the fix confusing, especially since there
are casts to both signed and unsigned char.

~Ryan

