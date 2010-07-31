Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0GaWv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 18:51:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58322 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab0GaWvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 18:51:55 -0400
Date: Sat, 31 Jul 2010 23:51:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ondrej Zary <linux@rainbow-software.org>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] cyber2000fb: fix machine hang on module load
Message-ID: <20100731225120.GC3633@n2100.arm.linux.org.uk>
References: <201007312255.30729.linux@rainbow-software.org> <4C5493DD.7010402@garzik.org> <20100731212509.GA3633@n2100.arm.linux.org.uk> <4C54A5A7.9080008@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C54A5A7.9080008@garzik.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 06:37:27PM -0400, Jeff Garzik wrote:
> On 07/31/2010 05:25 PM, Russell King - ARM Linux wrote:
>> No such luck.  It's a proprietary Integraphics chip, mainly used in
>> ARM Netwinders some 10 years ago.  It's completely different from the
>> S3 chips such as Trio64.
>
> Ah, I stand corrected.  Maybe that was cyberfb I was remembering...

I think so - the old cyberfb.h contained this:
-/* s3 commands */
-#define S3_BITBLT       0xc011
-#define S3_TWOPOINTLINE 0x2811
-#define S3_FILLEDRECT   0x40b1

so yes, it was similar to the S3 driver.
