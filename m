Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1DYVDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:03:39 -0400
Received: from kroah.org ([198.145.64.141]:47399 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab1DYVDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 17:03:36 -0400
Date: Mon, 25 Apr 2011 14:03:23 -0700
From: Greg KH <greg@kroah.com>
To: Melchior FRANZ <melchior.franz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915 completely unusable in 2.6.38.x
Message-ID: <20110425210323.GA23418@kroah.com>
References: <4DB53B79.4070704@kernelpanic.ru>
 <201104252210.46523@rk-nord.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104252210.46523@rk-nord.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 10:10:46PM +0200, Melchior FRANZ wrote:
> * Boris B. Zhmurov -- Monday 25 April 2011:
> > After upgrading RHEL6 to 2.6.28.x kernel, I have spontaneous "GPU hung"
> > 5-6 times per day.
> > xorg-x11-drv-intel-2.11.0-7.el6.i686 driver for Xorg.
> 
> JFTR, and although it seems to be a totally different problem with i915
> (or rather gm45), the whole 2.6.38.* series is also of limited use on my
> notebook, as described in this error message:
> 
>    https://bugzilla.kernel.org/show_bug.cgi?id=31522
> 
> I'm still using 2.6.38-rc8 (with SuSE 11.4/tumbleweed) on this machine
> (Acer TravelMate 5735Z-452G32Mnss), because that's the last version that
> supported KMS on my chipset. This older version works ok, so there's no
> reason to complain, but I'm still a bit suprised about that regression.

I don't understand, .38 should work as it has the above fix in it,
right?

Otherwise, what should be done for the .38-stable tree?

confused,

greg k-h
