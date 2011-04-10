Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1DJQTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 12:19:41 -0400
Received: from kroah.org ([198.145.64.141]:60532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab1DJQTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 12:19:37 -0400
Date: Sun, 10 Apr 2011 09:20:33 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][WAS:bcmai][PATCH V2] axi: add AXI bus driver
Message-ID: <20110410162033.GA4358@kroah.com>
References: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
 <20110408220157.GC26019@kroah.com>
 <BANLkTinZbw=GvkThyjMHbeQQ5arRVf2FUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinZbw=GvkThyjMHbeQQ5arRVf2FUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 10, 2011 at 05:52:27PM +0200, Rafał Miłecki wrote:
> 2011/4/9 Greg KH <greg@kroah.com>:
> > On Fri, Apr 08, 2011 at 09:45:00PM +0200, Rafał Miłecki wrote:
> >> TODO:
> >> - Interrupts
> >> - Reloading driver
> >
> > Please add to the TODO list:
> >        - Documentation/ABI entries for new sysfs files
> >        - proper Kconfig entry documentation for the different options
> 
> Could you tell me sth more about this? How am I expected to document this stuff?
> 
> Should I create Documentation/ABI/testing/sysfs-bus-axi or what?
> 
> Of course you can just point me to some place where I can read about
> proper documenting.

Documentation/ABI/README

