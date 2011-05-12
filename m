Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab1ELHKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:10:52 -0400
Received: from host171.canaca.com ([67.55.55.225]:43847 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab1ELHKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:10:50 -0400
X-Greylist: delayed 2746 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 May 2011 03:10:49 EDT
Message-ID: <0bcda95e38da7ce6fd696075f6d61baf.squirrel@host171.canaca.com>
In-Reply-To: <20110512042218.12859.66600.stgit@localhost6.localdomain6>
References: <20110512042218.12859.66600.stgit@localhost6.localdomain6>
Date: Thu, 12 May 2011 02:24:59 -0400
Subject: Re: [RFC PATCH] input: Add wiichuck driver
From: simon@mungewell.org
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds a driver for the Nintendo Nunchuck (wiimote accessory)
> attached to an i2c bus via something like a wiichuck adapter board
> from Sparkfun.
>

I have not tested your driver, will try to find some time next week.

There are also a handful of devices which can be connected as such:
http://www.wiibrew.org/wiki/Wiimote/Extension_Controllers

You might want to consider the possibility that the Nunchuck/Others are
connected via a MotionPlus, in which case the data is interleaved with
Gyro data.

Simon.

PS. If you're really cheap you can (ab)use the I2C DDC link of the VGA
port to connect devices.... it's what I do :-)


