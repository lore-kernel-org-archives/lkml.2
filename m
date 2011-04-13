Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab1DMVDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:03:19 -0400
Received: from kroah.org ([198.145.64.141]:59871 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934Ab1DMVDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:03:14 -0400
Date: Wed, 13 Apr 2011 14:00:57 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH V4] axi: add AXI bus driver
Message-ID: <20110413210057.GA7523@kroah.com>
References: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
 <20110413163113.GA24015@kroah.com>
 <BANLkTin-4HrJzNrLOxRy_-a98S3ZF4aSQw@mail.gmail.com>
 <BANLkTimBZK8i3EgihB85HqTJ+wOz89uwTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimBZK8i3EgihB85HqTJ+wOz89uwTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 10:37:44PM +0200, Gábor Stefanik wrote:
> On Wed, Apr 13, 2011 at 9:39 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
> > Hm, I'm not sure. Using EXPORT_SYMBOL_GPL will forbid closed source
> > drivers from using our bus driver, right? I'm don't have preferences
> > on this, if you prefer us to force GPL, I can.
> 
> Isn't EXPORT_SYMBOL_GPL for symbols that are considered to form a
> tight coupling between the kernel and users of the symbol? Using _GPL
> just because you are against proprietary drivers in general and want
> to force GPL on HW vendors is wrong.

It shows _intent_.  Not to say that functions that are not exported in
this manner do not also require only GPL kernel code to be used as well
at all.

See the archives for more details if you are curious about it, it's been
covered numerous times in the past.

thanks,

greg k-h
