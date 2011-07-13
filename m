Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab1GMQys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:54:48 -0400
Received: from adelie.canonical.com ([91.189.90.139]:48306 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab1GMQyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:54:46 -0400
Date: Wed, 13 Jul 2011 11:54:40 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Chris Ball <cjb@laptop.org>
cc: Arnd Bergmann <arnd@arndb.de>, Manoj Iyer <manoj.iyer@canonical.com>,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        matsumur@nts.ricoh.co.jp, linux-pci@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock
 frequency
In-Reply-To: <m262n62kgf.fsf@bob.laptop.org>
Message-ID: <alpine.DEB.2.02.1107131154000.3174@lazy>
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com> <m2sjqa2q93.fsf@bob.laptop.org> <alpine.DEB.2.02.1107131031360.3174@lazy> <201107131835.25217.arnd@arndb.de> <m262n62kgf.fsf@bob.laptop.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, Jul 13 2011, Arnd Bergmann wrote:
>> Not much. This card only has a 6MB/s write speed, which is well below
>> what a 50 MHz bus can do. It mgiht be different on a fast eMMC device
>> or a Sandisk Extreme Pro UHS-1 card.
>
> Okay, I see.  I think we're good for now, then -- hopefully anyone using
> a UHS card on their laptop will see the printk when wondering why their
> performance isn't great and get in touch with us, and we can investigate
> more then.
>
> I've pushed Manoj's patch to mmc-next for 3.1 now, with the printk
> changes and a stable@ tag.
>

Thanks Chris!

> Thanks again,
>
> - Chris.
> -- 
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
