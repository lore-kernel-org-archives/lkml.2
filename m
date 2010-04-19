Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0DSPVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:21:17 -0400
Received: from 007.netroom.de ([194.0.247.207]:19940 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308Ab0DSPVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:21:16 -0400
Message-ID: <4BCC74E6.1040902@draisberghof.de>
Date: Mon, 19 Apr 2010 17:21:10 +0200
From: Josua Dietze <digidietze@draisberghof.de>
Reply-To: digidietze@draisberghof.de
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Stefan Assmann <sassmann@redhat.com>
CC: mdharm-kernel@one-eyed-alien.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: expose Huawei E1550 3G modem
References: <4BCC5071.4010509@redhat.com> <4BCC6206.4030003@draisberghof.de> <4BCC63EB.4010204@redhat.com> <20100419141907.GN26130@one-eyed-alien.net> <4BCC6FAF.2030809@redhat.com>
In-Reply-To: <4BCC6FAF.2030809@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Assmann schrieb:
> You're right about that. For the E1550 it doesn't hide any devices. I'm
> still able to access the virtual CDROM and the microSD card. Josua, you
> might know more about that, isn't the hidding of the CDROM/microSD part
> done separately?

This behaviour depends on the respective device. Most devices 
don't re-expose the installation medium after switching, some do.

Anyway, usb_modeswitch is on the road to becoming a standard 
part of the big distributions, so users won't have to look for 
it actively.

Josua Dietze
