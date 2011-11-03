Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab1KCOsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:48:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:55086 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1KCOsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:48:07 -0400
Message-ID: <4EB2A987.2040805@windriver.com>
Date: Thu, 3 Nov 2011 10:47:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Kevin Hilman <khilman@ti.com>
CC: Axel Lin <axel.lin@gmail.com>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH RESEND] ARM: OMAP: omap_device: Include linux/export.h
References: <1320303638.17983.5.camel@phoenix> <87d3d9i8ni.fsf@ti.com>
In-Reply-To: <87d3d9i8ni.fsf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-03 10:26 AM, Kevin Hilman wrote:
> Axel Lin <axel.lin@gmail.com> writes:
> 
>> Include linux/export.h to fix below build warning:
>>
>>   CC      arch/arm/plat-omap/omap_device.o
>> arch/arm/plat-omap/omap_device.c:1055: warning: data definition has no type or storage class
>> arch/arm/plat-omap/omap_device.c:1055: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
>> arch/arm/plat-omap/omap_device.c:1055: warning: parameter names (without types) in function declaration
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Thanks, will queue as a fix for v3.2-rc

It is probably better if I track this, since export.h won't
exist until Linus pulls the module.h-split tree, and I'm
guessing that will be closer to the end of the merge window.

Thanks,
Paul.

> 
> Kevin
