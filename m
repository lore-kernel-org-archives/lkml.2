Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab2ECVQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:16:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43752 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2ECVQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:16:06 -0400
Message-ID: <4FA2F592.1040104@suse.cz>
Date: Thu, 03 May 2012 23:16:02 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120428 Thunderbird/14.0a2
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
References: <20120409101119.47e770b2@jbarnes-desktop> <4F83F3B5.8080704@suse.cz> <20120410092619.26a15165@jbarnes-desktop> <4F8477D1.4080102@suse.cz> <20120410113448.540e4c1d@jbarnes-desktop> <4F848F88.7060009@suse.cz> <20120410203212.GN4115@phenom.ffwll.local> <20120410133411.52dc52ed@jbarnes-desktop> <20120411104012.GI4296@phenom.ffwll.local> <4FA2E2D8.5050303@suse.cz> <20120503211537.GN4983@phenom.ffwll.local>
In-Reply-To: <20120503211537.GN4983@phenom.ffwll.local>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 11:15 PM, Daniel Vetter wrote:
>>> Shot in the dark, let's disable msi a bit. Can you try the below patch?
>>
>> Yeah, no IRQ_NONE at the end of i915_driver_irq_handler now. So MSI is
>> busted, either in the card, the chipset or the kernel. Any idea how to
>> find out?
> 
> Ok, so MSI is busted. Can you please paste lspci -nn for you intel gpu?

Sure:
00:02.0 VGA compatible controller [0300]: Intel Corporation 82G33/G31
Express Integrated Graphics Controller [8086:29c2] (rev 02)

thanks,
-- 
js
suse labs


