Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722Ab0HEGWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:22:43 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:49283 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758840Ab0HEGWl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:22:41 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        Viresh KUMAR <viresh.kumar@st.com>
Date: Thu, 5 Aug 2010 08:22:13 +0200
Subject: RE: [PATCH] RFC: AMBA bus discardable probe() function
Thread-Topic: [PATCH] RFC: AMBA bus discardable probe() function
Thread-Index: Acs0I8hGOuzgePgNRSC22f6wx4HV/gAQhCWQ
Message-ID: <CEE6BB42CAD6E947908279175AF8470A0262E58F84@EXDCVYMBSTM006.EQ1STM.local>
References: <1280925543-6862-1-git-send-email-linus.walleij@stericsson.com>
 <20100804222410.GB12502@n2100.arm.linux.org.uk>
In-Reply-To: <20100804222410.GB12502@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Russell]

> which gives a total of 5188 bytes for all the above probe functions.
> However, in order to free this, we're adding 184 bytes of code and
> literal pool to achieve this:
> (...) 
> The overall kernel size is 3877020 bytes, which means we're potentially
> allowing for 0.13% of the kernel to be freed at run time - which may
> equate to one or at most two additional pages.

We have the PL022 as well, and the PL08x is being added but it will
likely stay in that ballpark figure.

But overall that does not seem to be worth it, so let's drop it
for the time being. CC:ing the linux-embedded folks that
often worry about footprint size to see if someone oppose. Also
CC Viresh who works on a platform for e.g. set-top boxes using
these PrimeCells which I think may be memory-constrained.

Yours,
Linus Walleij


