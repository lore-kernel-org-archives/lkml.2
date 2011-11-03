Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969Ab1KCRsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:48:54 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:49366 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933174Ab1KCRsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:48:51 -0400
From: Kevin Hilman <khilman@ti.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Axel Lin <axel.lin@gmail.com>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH RESEND] ARM: OMAP: omap_device: Include linux/export.h
Organization: Texas Instruments, Inc.
References: <1320303638.17983.5.camel@phoenix> <87d3d9i8ni.fsf@ti.com>
	<4EB2A987.2040805@windriver.com>
Date: Thu, 03 Nov 2011 10:48:44 -0700
In-Reply-To: <4EB2A987.2040805@windriver.com> (Paul Gortmaker's message of
	"Thu, 3 Nov 2011 10:47:35 -0400")
Message-ID: <877h3hhzb7.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> writes:

> On 11-11-03 10:26 AM, Kevin Hilman wrote:
>> Axel Lin <axel.lin@gmail.com> writes:
>> 
>>> Include linux/export.h to fix below build warning:
>>>
>>>   CC      arch/arm/plat-omap/omap_device.o
>>> arch/arm/plat-omap/omap_device.c:1055: warning: data definition has no type or storage class
>>> arch/arm/plat-omap/omap_device.c:1055: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
>>> arch/arm/plat-omap/omap_device.c:1055: warning: parameter names (without types) in function declaration
>>>
>>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> 
>> Thanks, will queue as a fix for v3.2-rc
>
> It is probably better if I track this, since export.h won't
> exist until Linus pulls the module.h-split tree, and I'm
> guessing that will be closer to the end of the merge window.

OK, sounds good.  Feel free to add:

Acked-by: Kevin Hilman <khilman@ti.com>

Thanks,

Kevin


