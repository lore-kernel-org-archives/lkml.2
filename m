Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2GUQnd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 12:43:33 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59773 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2GUQnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 12:43:32 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 21 Jul 2012 09:43:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Oliver Neukum <oneukum@suse.de>
Cc: Johannes Winkelmann <johannes.winkelmann@gmail.com>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Jean Delvare <khali@linux-fr.org>,
        Johannes Winkelmann <johannes.winkelmann@sensirion.com>
Subject: Re: [RFC][PATCH] hwmon: add support for Sensirion C1 sensor
Message-ID: <20120721164344.GA13261@roeck-us.net>
References: <1342789042-13433-1-git-send-email-johannes.winkelmann@sensirion.com>
 <6190165.D1PKLQQHEK@linux-lqwf.site>
 <CAEYbzYsu_xhXJgbYKPj-rz-d26wTTM98+oyEDWbXMO5VNC5sgw@mail.gmail.com>
 <13845450.qTFZGkrci5@linux-lqwf.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13845450.qTFZGkrci5@linux-lqwf.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 05:14:49PM +0200, Oliver Neukum wrote:
> On Friday 20 July 2012 17:13:51 Johannes Winkelmann wrote:
> > On Fri, Jul 20, 2012 at 4:03 PM, Oliver Neukum <oneukum@suse.de> wrote:
> 
> > > We have dedicated macros for conversion of endianness.
> > 
> > Like this:
> > 		val = swab16p((__le16 *)buf);
> > 		data->temperature = ((21875 * val) >> 13) - 45000;
> > 		val = swab16p((__le16 *)(buf+2));
> > 		data->humidity = ((15000 * val) >> 13) - 10000;
> 
> I was thinking of be16_to_cpu()
> 
be16_to_cpup(), maybe.

Guenter
