Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab1EPDzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 23:55:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42363 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab1EPDyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 23:54:46 -0400
Date: Sun, 15 May 2011 15:17:39 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: simon@mungewell.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [RFC PATCH] input: Add wiichuck driver
Message-ID: <20110515211739.GA30725@angua.secretlab.ca>
References: <20110512042218.12859.66600.stgit@localhost6.localdomain6>
 <0bcda95e38da7ce6fd696075f6d61baf.squirrel@host171.canaca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bcda95e38da7ce6fd696075f6d61baf.squirrel@host171.canaca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 02:24:59AM -0400, simon@mungewell.org wrote:
> > This patch adds a driver for the Nintendo Nunchuck (wiimote accessory)
> > attached to an i2c bus via something like a wiichuck adapter board
> > from Sparkfun.
> >
> 
> I have not tested your driver, will try to find some time next week.
> 
> There are also a handful of devices which can be connected as such:
> http://www.wiibrew.org/wiki/Wiimote/Extension_Controllers
> 
> You might want to consider the possibility that the Nunchuck/Others are
> connected via a MotionPlus, in which case the data is interleaved with
> Gyro data.
> 
> Simon.
> 
> PS. If you're really cheap you can (ab)use the I2C DDC link of the VGA
> port to connect devices.... it's what I do :-)

Heh.  I've actually got it wired up to the i2c bus on a BeagleBoard from TI.

I've got a new version of the driver which I'll post when I get back
home and have a chance to properly test it.  I've implemented Nunchuck
and Classic Controller support so I could play with implementing
multiple protocols in a clean way (even though I don't actually have a
classic controller yet).  Motion Plus should be straight forward to
add, but I'll probably leave that as an exercise for somebody else.

g.

