Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0KBBaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:30:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43481 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab0KBBao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=KMPV7irOBT9s6i5wLt54+pNfxRme3xugz6iUzZVr1m3YbepNwwF9hlgCcad7JKQV3k
         tmqYuTbO8Oxw6eCNjZF/guUyvok/GEyCh0IAPMmJZmR2AOgJ8xsOJDemcOJ/b1SwhUos
         rZBxjn50uLhkUSFPvMpgv0teyM6bVCRF2tPfE=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <AANLkTikmRr3_T8ObcjWgnZdsDTtE+ab=r42z+y7vb0sF@mail.gmail.com>
References: <1288660377.20990.1.camel@mola> <AANLkTikmRr3_T8ObcjWgnZdsDTtE+ab=r42z+y7vb0sF@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 2 Nov 2010 09:30:23 +0800
Message-ID: <AANLkTimt+iOzh3nSAaudKZqtWT2=rsztJ7inw5Ebtaa9@mail.gmail.com>
Subject: Re: [PATCH] dma: imx-dma: fix imxdma_probe error path
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Pengutronix <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/2 Thiago Farina <tfransosi@gmail.com>:
> On Mon, Nov 1, 2010 at 11:12 PM, Axel Lin <axel.lin@gmail.com> wrote:
>> otherwise, i will be -1 inside the latest iteration of the while loop.
>>
> nit: s/otherwise, i will be/Otherwise, it will be ?

I mean the i variable will become -1 inside the latest iteration of
the while loop.

Should I resend the patch?

Regards,
Axel
