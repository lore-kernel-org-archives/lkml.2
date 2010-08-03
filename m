Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab0HCHXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:23:00 -0400
Received: from mail.aixigo.de ([195.14.232.227]:17040 "EHLO mail.aixigo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab0HCHW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:22:59 -0400
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Aug 2010 03:22:57 EDT
Message-ID: <4C57BF1E.9080804@aixigo.de>
Date: Tue, 03 Aug 2010 09:02:54 +0200
From: Harald Dunkel <harald.dunkel@aixigo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100721 Mnenhy/0.8.3 Thunderbird/3.1.1
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: 2.6.34 on Samsung P460: reset after "Waiting for /dev to be fully
 	populated"
References: <4BFB947E.9080509@aixigo.de> <20100525184621.89487735.akpm@linux-foundation.org> <AANLkTil_-pV3jBkdBrWlz6iKr_lo2b3ZUFUvP8MFoByg@mail.gmail.com> <4BFD1F93.7080000@aixigo.de>
In-Reply-To: <4BFD1F93.7080000@aixigo.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

Sorry for the delay.

It crashes when the "processor" acpi module is loaded.
If I blacklist this module, then the laptop boots fine.

The same problem exists for 2.6.35 and older kernels.

Of course I would be glad to help to track this down.


Regards

Harri

