Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab0GCU4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 16:56:18 -0400
Received: from bamako.nerim.net ([62.4.17.28]:64601 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab0GCU4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 16:56:17 -0400
Date: Sat, 3 Jul 2010 22:56:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "=?UTF-8?B?5a6+6KW/6JKZ?=" <binximeng@gmail.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
       Jim Cromie <jim.cromie@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ethan Lawrence <e.law87@yahoo.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, lars4910@hotmail.com,
       birdie@permonline.ru, jadcock@cox.net
Subject: Re: [PATCH/RFC v2] hwmon: Add support for W83667HG-B and 
 W83667HG-I to w83627ehf driver.
Message-ID: <20100703225613.1236bf07@hyperion.delvare>
In-Reply-To: <1278152148.7319.11.camel@xli51>
References: <1278062606-29000-1-git-send-email-guenter.roeck@ericsson.com>
	<20100703103536.2fdd833e@hyperion.delvare>
	<1278152148.7319.11.camel@xli51>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 宾西蒙,

On Sat, 03 Jul 2010 12:15:48 +0200, 宾西蒙 wrote:
> 在 2010-07-03六的 10:35 +0200，Jean Delvare写道：
> > Hi Guenter,
> > 
> > On Fri, 2 Jul 2010 02:23:26 -0700, Guenter Roeck wrote:
> > > +    w83667hg-i   9      5       3       3      0xb340 0xc1    0x5ca3
> > 
> > As discussed before, this one is a 677 series, not 667. That being
> > said, I admit that the device ID proximity between the 667HG-B and the
> > 677HG-I is troubling, and invites to optimism as far as compatibility
> > between these two chips is concerned.
> 
> I think we got something confused here, I was looking for the W836
> *seven* 7 HG-I driver (which has ID 0xb470) and not the W836 *six* 7
> HG-I one, although maybe someone else might benefit from that one.

Yes, there was some confusion. For one thing, the W83667HG-I does not
exist. And for another, I have no idea where Guenter found the device
id 0xb340. None of the Nuvoton W836x7HG datasheets I have mention this
ID. All I know of is 0xb350 for the W83667HG-B and 0xb470 for the
W83677HG-I (which apparently was renamed to something different
meanwhile.)

-- 
Jean Delvare
