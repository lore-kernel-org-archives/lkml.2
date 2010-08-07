Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0HGR2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 13:28:36 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43211 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab0HGR2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 13:28:34 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimHbcF+fz=aBMLdhLo2s-rhfNvaPCtqE8nYJ8aT@mail.gmail.com>
References: <4C58A7AA.8020007@codeaurora.org> <20100803235631.GA17759@suse.de> 
	<4C58AE15.6090900@codeaurora.org> <20100804000945.GA19729@suse.de> 
	<4C58B1B6.9050005@quicinc.com> <AANLkTikVzh9=DvvUPbKmDeo6k2-pPVSnjH+GxAPdQFO4@mail.gmail.com> 
	<20100806142727.GB4921@suse.de> <AANLkTi=VbVed09=u-Ea0L8c_CWZ_CLLjWH9ZjD2dyg6Y@mail.gmail.com> 
	<20100806234635.GC16793@suse.de> <AANLkTimHbcF+fz=aBMLdhLo2s-rhfNvaPCtqE8nYJ8aT@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 7 Aug 2010 11:28:13 -0600
X-Google-Sender-Auth: 4FREdLR1Ml4Wb-1OTnFUodx1dsc
Message-ID: <AANLkTimjXd=SL61KvjDfvJ-JtXsSVW9pwOYBFUHX0mVp@mail.gmail.com>
Subject: Re: [RFC PATCH] platform: Faciliatate the creation of pseduo-platform 
	busses
To: Greg KH <gregkh@suse.de>
Cc: Patrick Pannuto <ppannuto@quicinc.com>,
        Patrick Pannuto <ppannuto@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "damm@opensource.se" <damm@opensource.se>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "dtor@mail.ru" <dtor@mail.ru>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 7, 2010 at 12:35 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, Aug 6, 2010 at 5:46 PM, Greg KH <gregkh@suse.de> wrote:
>> That would be nice, but take your "standard" PC today:
>>        > ls /sys/devices/platform/
>>        Fixed MDIO bus.0  i8042  pcspkr  power  serial8250  uevent vesafb.0
>>
>> There are tty devices below the serial port, which is nice to see, but
>> the others?  I don't know what type of bus they would be on, do you?
[...]
> I wouldn't have any problem modifying those specific drivers to
> register under something like /sys/devices/legacy, but I don't really
> think it is in any way necessary.

Or for that matter, make those drivers explicitly use
/sys/devices/platform so that I don't cause churn on PCs.  :-)  I'd
like to be rid of it as default behaviour for embedded though.

g.
