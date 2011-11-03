Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1KCO1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:27:14 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:47532 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765Ab1KCO1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:27:13 -0400
From: Kevin Hilman <khilman@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH RESEND] ARM: OMAP: omap_device: Include linux/export.h
Organization: Texas Instruments, Inc.
References: <1320303638.17983.5.camel@phoenix>
Date: Thu, 03 Nov 2011 07:26:57 -0700
In-Reply-To: <1320303638.17983.5.camel@phoenix> (Axel Lin's message of "Thu,
	03 Nov 2011 15:00:38 +0800")
Message-ID: <87d3d9i8ni.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin <axel.lin@gmail.com> writes:

> Include linux/export.h to fix below build warning:
>
>   CC      arch/arm/plat-omap/omap_device.o
> arch/arm/plat-omap/omap_device.c:1055: warning: data definition has no type or storage class
> arch/arm/plat-omap/omap_device.c:1055: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
> arch/arm/plat-omap/omap_device.c:1055: warning: parameter names (without types) in function declaration
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks, will queue as a fix for v3.2-rc

Kevin
