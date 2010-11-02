Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0KBBpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:45:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36383 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab0KBBpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RwNfOVmBuQh8vs2iPiT1PF2DCM3rRR2kP5d9KnlUYgRcj/TSi41VPyV1gHnQD3Ok09
         xkalamrTi+jQavZHJEhEfeN7Dz7k6+LbdK6KhaviuU07UKH7IbbKSuPnXFhpGdPcoxp/
         3V0vcJKMd/OMmCYcZdUTq6r3EuqF0yeVgfEMQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTimt+iOzh3nSAaudKZqtWT2=rsztJ7inw5Ebtaa9@mail.gmail.com>
References: <1288660377.20990.1.camel@mola>
	<AANLkTikmRr3_T8ObcjWgnZdsDTtE+ab=r42z+y7vb0sF@mail.gmail.com>
	<AANLkTimt+iOzh3nSAaudKZqtWT2=rsztJ7inw5Ebtaa9@mail.gmail.com>
Date: Mon, 1 Nov 2010 23:45:48 -0200
Message-ID: <AANLkTin+SooayjF06uw_ZzvEi8bnu-hgspNdm51OBKJq@mail.gmail.com>
Subject: Re: [PATCH] dma: imx-dma: fix imxdma_probe error path
From: Thiago Farina <tfransosi@gmail.com>
To: axel.lin@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Pengutronix <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 11:30 PM, Axel Lin <axel.lin@gmail.com> wrote:
> 2010/11/2 Thiago Farina <tfransosi@gmail.com>:
>> On Mon, Nov 1, 2010 at 11:12 PM, Axel Lin <axel.lin@gmail.com> wrote:
>>> otherwise, i will be -1 inside the latest iteration of the while loop.
>>>
>> nit: s/otherwise, i will be/Otherwise, it will be ?
>
> I mean the i variable will become -1 inside the latest iteration of
> the while loop.
>
> Should I resend the patch?
>
Your call, as I got confused others can get confused too.
