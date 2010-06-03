Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab0FCRr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:47:56 -0400
Received: from void.printf.net ([89.145.121.20]:45558 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab0FCRrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:47:55 -0400
X-Greylist: delayed 1703 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 13:47:55 EDT
From: Chris Ball <cjb@laptop.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/2] mmc: split mmc_sd_init_card()
References: <1-1000-12432-1274803827-7569@rere.qmqm.pl>
	<20100528144027.3c868841.akpm@linux-foundation.org>
	<20100531155846.GA9493@rere.qmqm.pl> <4C0774A8.2030704@nokia.com>
Date: Thu, 03 Jun 2010 13:21:23 -0400
In-Reply-To: <4C0774A8.2030704@nokia.com> (Adrian Hunter's message of "Thu, 03
	Jun 2010 12:23:52 +0300")
Message-ID: <m3hblk8224.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   > That is a bit vague.  An SD card is a memory.  An SDIO "card" is
   > an I/O connection made using the same physical interface as an SD
   > card and a very similar protocal to SD cards (at least with
   > respect to reading and writing).  I do not understand how a card
   > can be SD and SDIO.  Are you sure you are not talking about a
   > controller that supports SD and SDIO?  A lot of controllers do
   > that.

Adrian, I presume we're talking about something like:

http://www.arasan.com/products/sd/SD-Combo-Flyer.pdf

Michał, could you let us know which SD-combo device(s) in particular
you've been working with?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
