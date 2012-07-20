Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab2GTPPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 11:15:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab2GTPPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 11:15:38 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Johannes Winkelmann <johannes.winkelmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Johannes Winkelmann <johannes.winkelmann@sensirion.com>
Subject: Re: [RFC][PATCH] hwmon: add support for Sensirion C1 sensor
Date: Fri, 20 Jul 2012 17:14:49 +0200
Message-ID: <13845450.qTFZGkrci5@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc6-117-g918227b-1-vanilla; KDE/4.8.4; x86_64; ; )
In-Reply-To: <CAEYbzYsu_xhXJgbYKPj-rz-d26wTTM98+oyEDWbXMO5VNC5sgw@mail.gmail.com>
References: <1342789042-13433-1-git-send-email-johannes.winkelmann@sensirion.com> <6190165.D1PKLQQHEK@linux-lqwf.site> <CAEYbzYsu_xhXJgbYKPj-rz-d26wTTM98+oyEDWbXMO5VNC5sgw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2012 17:13:51 Johannes Winkelmann wrote:
> On Fri, Jul 20, 2012 at 4:03 PM, Oliver Neukum <oneukum@suse.de> wrote:

> > We have dedicated macros for conversion of endianness.
> 
> Like this:
> 		val = swab16p((__le16 *)buf);
> 		data->temperature = ((21875 * val) >> 13) - 45000;
> 		val = swab16p((__le16 *)(buf+2));
> 		data->humidity = ((15000 * val) >> 13) - 10000;

I was thinking of be16_to_cpu()

	Regards
		Oliver

