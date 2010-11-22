Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0KVLcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 06:32:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:56504 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab0KVLcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 06:32:50 -0500
Message-ID: <4CEA54C9.4030300@infradead.org>
Date: Mon, 22 Nov 2010 09:32:25 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Raffaele Recalcati <lamiaposta71@gmail.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: tvp5150 extension to tvp5151
References: <AANLkTinTwyioFt2mGmetK=rfj-q_7hLBQ_FR_aE20FXZ@mail.gmail.com>
In-Reply-To: <AANLkTinTwyioFt2mGmetK=rfj-q_7hLBQ_FR_aE20FXZ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Raffaele,

Em 19-11-2010 16:26, Raffaele Recalcati escreveu:
> I need to support fully tvp5151.
> So I'm trying to understand your driver, that is ready for VBI and not
> for video acquisition.
> I also take sometimes a look at tvp514x.c, for instance trying to add
> VIDIOC_ENUM_FMT and other ioctls.
> I think we can move from tvp5150.c to tvp515x.c, maybe...
> I don't think is good to have tvp51xx.c because tvp514x.c family is
> more complex (more inputs...).
> By now I'm using tvp5150.c with some modifications and video acquisition works.
> I need to complete the support in order to have gstreamer fully running.
> I'm working on 2.6.32, but I have planned to port it to mainline.

Renaming it to tvp515x.c and adding support for tvp5051 seems a good way.
With tvp5150, video acquisition works fine with several devices with em28xx,
although we may need to add more video formats at the media bus, depending
on what you're doing. I didn't test VBI support on it, because the devices
I have are based on em28xx, and I didn't find any way to capture the VBI
decoded packages and sent to userspace with that design. So, the basic stuff
is there, but maybe some adjusts may be needed for VBI.

> Do you have any suggestion for my work?

The better is to submit the patches you have, for us to apply upstream.

Cheers,
Mauro
