Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab2HGRXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:23:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60542 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2HGRXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:23:44 -0400
Subject: Re: [PATCH] driver: misc: bmp085: remove "of_match_table" property.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Warner Losh <imp@bsdimp.com>
In-Reply-To: <20120807105225.GT16861@opensource.wolfsonmicro.com>
Date: Tue, 7 Aug 2012 11:23:40 -0600
Cc: Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Sourav Poddar <sourav.poddar@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4CEA7FE1-B4B7-4702-BD94-C04154014763@bsdimp.com>
References: <1344245324-16704-1-git-send-email-sourav.poddar@ti.com> <20120806093033.GH17551@arwen.pp.htv.fi> <20120806154214.GC29272@sirena.org.uk> <20120807054342.GF8468@arwen.pp.htv.fi> <20120807105225.GT16861@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7, 2012, at 4:52 AM, Mark Brown wrote:

> On Tue, Aug 07, 2012 at 08:43:44AM +0300, Felipe Balbi wrote:
>> On Mon, Aug 06, 2012 at 04:42:14PM +0100, Mark Brown wrote:
> 
>>> It's good practice to have an explict compatible string even if the
>>> default happens to work in order to avoid any name clashes.
> 
>> of_i2c.c makes no use whatsoever of the compatible string. See that it
>> will build an i2c_boardinfo and register a new device. That compatible
> 
> If that's all that's done it seems like a bug frankly, certainly based
> on previous discussions it ought to be.  There are collisions out there,
> they've just happened to not bite us yet

Also keep in mind that the device tree is supposed to be a description of the hardware, and different implementations of the device tree may use the compatible string.

Warner

