Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab1JFEHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 00:07:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53112 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1JFEHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 00:07:31 -0400
Date: Thu, 6 Oct 2011 09:36:59 +0530
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon class driver registration with a device number
Message-ID: <20111006040656.GA2125@ubuntu.ubuntu-domain>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
 <1317839407.3983.46.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317839407.3983.46.camel@groeck-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I can not comment on the merits of your patch. Unless I am missing
> something, which may well be since I only spent a couple of minutes on
> it, other device classes don't seem to provide a similar API, so I don't
> know if or why it would make sense for hwmon. Maybe a driver which wants
> to register a character device interface should do so independently of
> hwmon.
> 

The idea here is to sit in the same class directory as of hwmon. Devices
registered with this interface will have "dev" under, for example,
/sys/class/hwmon/hwmon0/dev. To do the same inside the driver will be
a bit more involved than a call.

In my opinion other classes should also have similar interfaces.

> On the technical side, EXPORT_SYMBOL is missing.
> 
I will take care of that.

Regards
Himanshu
