Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab1HCMzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 08:55:16 -0400
Received: from void.printf.net ([89.145.121.20]:35473 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab1HCMzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 08:55:12 -0400
From: Chris Ball <cjb@laptop.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Ian Molton <ian@mnementh.co.uk>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: tmio: eliminate unused variable 'mmc' warning
References: <1312354138.14329.1.camel@phoenix>
	<Pine.LNX.4.64.1108030924440.28502@axis700.grange>
Date: Wed, 03 Aug 2011 08:55:01 -0400
In-Reply-To: <Pine.LNX.4.64.1108030924440.28502@axis700.grange> (Guennadi
	Liakhovetski's message of "Wed, 3 Aug 2011 09:26:25 +0200 (CEST)")
Message-ID: <m2liva7ize.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 03 2011, Guennadi Liakhovetski wrote:
> On Wed, 3 Aug 2011, Axel Lin wrote:
>
>> Fix below compile warning:
>>   CC      drivers/mmc/host/tmio_mmc.o
>> drivers/mmc/host/tmio_mmc.c: In function 'tmio_mmc_suspend':
>> drivers/mmc/host/tmio_mmc.c:30: warning: unused variable 'mmc'
>> drivers/mmc/host/tmio_mmc.c: In function 'tmio_mmc_resume':
>> drivers/mmc/host/tmio_mmc.c:45: warning: unused variable 'mmc'
>> 
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Good for 3.1, do we also push such "harmless" compiler warning fixes to 
> stable?
>
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Pushed for 3.1, thanks.  I don't think this is appropriate for stable.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
