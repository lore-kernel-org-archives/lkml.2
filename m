Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935817Ab0GPHpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:45:39 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56429 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S935713Ab0GPHph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:45:37 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jul 2010 03:45:37 EDT
X-Authenticated: #9246704
X-Provags-ID: V01U2FsdGVkX1/WP5Mnr8nWu/uc290Iy3LafWrETJA1uAdpgg4FRT
	+W29x07lsh9JMZ
Message-ID: <4C400C8E.8060500@gmx.info>
Date: Fri, 16 Jul 2010 09:38:54 +0200
From: Jens Rutschmann <Jens.Rutschmann@gmx.info>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Thunderbird/3.0.5
MIME-Version: 1.0
To: Pedro Ribeiro <pedrib@gmail.com>
CC: eusou15@yahoo.com, ibm-acpi-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, toralf.foerster@gmx.de,
        mjg59@srcf.ucam.org
Subject: Re: [ibm-acpi-devel] [PATCH] Remove 9 second reboot delay on Lenovo
 T400/T500
References: <4C3DCAA4.9050602@gmail.com>
In-Reply-To: <4C3DCAA4.9050602@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.07.2010 16:33 schrieb Pedro Ribeiro:
> Please consider this patch. Let me know if you would like me to change
> anything or if you don't agree with it. It applies cleanly to 2.6.35-rc5.
>
> The Lenovo T400 and T500 have an annoying 9 second delay when
> rebooting, unless reboot=pci is passed to the kernel command line.
> This delay happens from at least kernel 2.6.20.
>
> Make this change permanent by hardcoding the Tx00 on the
> arch/kernel/reboot.c pci quirks table.

Hi,

I just want to add to this discussion that this problem also occurs on my T61 with only Linux installed on it.
"reboot=pci" also removed the reboot delay here.

If you need some further information or want me to try some patches / old kernels I'd be glad to help.

Regards,
Jens
