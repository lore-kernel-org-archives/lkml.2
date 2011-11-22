Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1KVMCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:02:50 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63283 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab1KVMCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:02:49 -0500
Date: Tue, 22 Nov 2011 12:56:32 +0100
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
Message-ID: <20111122115632.GA5165@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <1321961573-4562-1-git-send-email-dave.martin@linaro.org>
References: <1321961573-4562-1-git-send-email-dave.martin@linaro.org> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have Acks on some of the driver patches and no comments on the
> rest.  I've been circulating these for some time, so if you're
> happy to pull those driver patches via your tree, please go ahead.

Sure I have no problem with the nomadik-rng.c, (so please have my
Acked-by: -- sorry for not noting it earlier) but I think this
file2alias thing needs a serious rework to split each bus in a
different file, using ELF sections like we do elsewhere.

I posted a patch last week but I got no comment at all. Maybe this
is the time to ask for comments? I can rebase and repost if needed.

  lkml.org/lkml/2011/11/4/125 (0/2: description of the work)
  lkml.org/lkml/2011/11/4/126 (1/2: turn the if plethora to table lookup)
  lkml.org/lkml/2011/11/4/127 (2/2: partial split to type-specific files).

thanks
/alessandro
