Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab1KVPV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:21:28 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63629 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab1KVPV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:21:26 -0500
Date: Tue, 22 Nov 2011 16:19:42 +0100
From: Alessandro Rubini <rubini@unipv.it>
To: dave.martin@linaro.org
Cc: linux@arm.linux.org.uk, patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com,
        a.zummo@towertech.it, alsa-devel@alsa-project.org, cjb@laptop.org,
        dan.j.williams@intel.com, dmitry.torokhov@gmail.com,
        grant.likely@secretlab.ca, perex@perex.cz, jassisinghbrar@gmail.com,
        julia@diku.dk, linus.walleij@linaro.org, linux-fbdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-watchdog@vger.kernel.org,
        lethal@linux-sh.org, Pawel.Moll@arm.com, rtc-linux@googlegroups.com,
        spi-devel-general@lists.sourceforge.net, tiwai@suse.de,
        vinod.koul@intel.com, wim@iguana.be
Subject: Re: [GIT PULL] ARM: amba: Enable module alias autogeneration for
 AMBA drivers
Message-ID: <20111122151942.GA24821@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20111122120756.GF2066@localhost.localdomain>
References: <20111122120756.GF2066@localhost.localdomain>
  <1321961573-4562-1-git-send-email-dave.martin@linaro.org>
  <20111122115632.GA5165@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>   lkml.org/lkml/2011/11/4/125 (0/2: description of the work)
>>   lkml.org/lkml/2011/11/4/126 (1/2: turn the if plethora to table lookup)
>>   lkml.org/lkml/2011/11/4/127 (2/2: partial split to type-specific files).
> 
> Splitting this up doesn't look like a silly idea -- I thought it was
> unfortunate to have to patch a core file just to add a bus type.
>
> I guess the question is how many new buses we get over time.

Well, CERN will have 2 in a short time. And I'm sure the bus concept
is so good that a number of them exists as external patches. Being
forced to patch a core file is not good, with conflicts that accumulate
over time.

I'd better be able to drop in my own file and add a kconfig-aware line
in Makefile.  I think the implementation is straightforward. Who should
I send it to?

thanks
/alessandro
