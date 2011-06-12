Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1FLMWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 08:22:19 -0400
Received: from wp186.webpack.hosteurope.de ([80.237.132.193]:59948 "EHLO
	wp186.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233Ab1FLMWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 08:22:18 -0400
Message-ID: <4DF4AF76.2070307@xaipete.org>
Date: Sun, 12 Jun 2011 14:22:14 +0200
From: Robert Uhl <ruhl@xaipete.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org
Subject: Re: Access to local APIC registers during an interrupt handler
References: <4DF389D1.4090909@xaipete.org> <19956.40070.962218.422362@pilspetsen.it.uu.se>
In-Reply-To: <19956.40070.962218.422362@pilspetsen.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;ruhl@xaipete.org;1307881338;d0cc2ac8;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.06.2011 13:01, Mikael Pettersson wrote:
>   >  movq (lapic_idregister), %rcx
>   >  movq (%rcx), %rcx
>
> You're doing a 64-bit load from a 32-bit lapic register.
>
> If changing the above movq (%rcx), %rcx to use movl instead makes it
> work in real HW, then you've found an accepts-invalid bug in qemu.

It works with movl, thank you very much!
I will send a bug report to the qemu team.
