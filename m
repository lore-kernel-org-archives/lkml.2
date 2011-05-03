Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1ECONA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:13:00 -0400
Received: from kroah.org ([198.145.64.141]:60744 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab1ECOM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:12:58 -0400
Date: Tue, 3 May 2011 07:13:45 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [RFC 1/5] platform-drivers-x86: add support for Technologic
 Systems TS-5xxx detection
Message-ID: <20110503141345.GB8056@kroah.com>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1304115712-5299-2-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20110429233230.GB24864@kroah.com>
 <1304368433-sup-4264@sfl>
 <20110502215535.GA30373@kroah.com>
 <20110503103919.5b0daa5e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503103919.5b0daa5e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 10:39:19AM +0100, Alan Cox wrote:
> > > I had a look at other drivers, and /sys/devices/platform/ts/ seems to be
> > > a good place to hold those entries (one per options as you suggested).
> > > Do you agree with that?
> > 
> > No, this is not a platform device, is it?  Only platform devices go
> > there, and I really doubt you have many of them for this board.
> 
> It seems analogous to some of the laptop helpers so I don't think it is
> that unreasonable to make the board config a platform device of its own -
> we don't really have a general solution to the board as a device, so if
> you look at equivalents on laptops and the like we have assorted platform
> control interfaces that are platform devices.

Platform control devices are great, I have no objection to that.  I do
object to random proc files to try to describe the fact that this board
has a rs232 port on it, when that is able to be determined elsewhere.

thanks,

greg k-h
