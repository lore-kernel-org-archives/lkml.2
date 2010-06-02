Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0FBDPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 23:15:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44670 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0FBDPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 23:15:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA1BBBBC9359F04AA639128AC0D5D1E9692AAF29@orsmsx502.amr.corp.intel.com>
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100601135102.GA8098@srcf.ucam.org>
	<1275426085.21962.967.camel@mulgrave.site>
	<201006020024.14220.rjw@sisk.pl>
	<1275431816.21962.1108.camel@mulgrave.site>
	<AANLkTikObnAZbyOxeYAhXcEbimO3XTTO-HlC9CD_HH6t@mail.gmail.com>
	<CA1BBBBC9359F04AA639128AC0D5D1E9692AAF29@orsmsx502.amr.corp.intel.com>
Date: Tue, 1 Jun 2010 20:15:17 -0700
Message-ID: <AANLkTinsgmHh7iLhESPXiTkoW9SL4H8E92-7bARpDxNX@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Gross, Mark" <mark.gross@intel.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>, Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/1 Gross, Mark <mark.gross@intel.com>:
...
>>4. It would be useful to change pm_qos_add_request to not allocate
>>anything so can add constraints from init functions that currently
>>cannot fail.
> [mtg: ] I'm not sure how to do this but I agree it would be good.  I guess we could have a block of pm_qos requests pre-allocated statically and re-use them.  In practice there will not be more than a handful of requests ever.  Dynamic allocation does seem like a bit of a waste.

The calling code will have to store a pointer to your structure
anyway, you may as well have them provide the whole structure.

-- 
Arve Hjønnevåg
