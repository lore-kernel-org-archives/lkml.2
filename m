Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab2AAHdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 02:33:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48550 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2AAHdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 02:33:03 -0500
Date: Sun, 1 Jan 2012 01:32:55 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Roman Mamedov <rm@romanrm.ru>,
        Manuel Roeder <manuel_roeder@gmx.de>,
        Michael Ott <michael@king-coder.de>
Subject: [2.6.37 -> 2.6.38 regression] "mv64xxx: I2C bus locked, block: 1,
 time_left: 0" every few seconds
Message-ID: <20120101073255.GA2402@elie.hsd1.il.comcast.net>
References: <20120101042401.4bef017e@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120101042401.4bef017e@natsu>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Roman Mamedov wrote[1]:

> This bug is still present for me in the latest kernel version in
> Debian testing (3.1.6).
>
> The last properly working kernel version seems to be:
[...]
> And the problem occurs since:
[...]

Thanks.  Arnaud, any hints?  To summarize:

 - Michael Ott reported with Debian kernel 2.6.38-3 (which is closely
   based on stable v2.6.38.2):

	syslog tell me every few seconds:
	i2c i2c-0: mv64xxx: I2C bus locked, block: 1, time_left: 0

 - Manuel Roeder reported the same and found that upstream v2.6.38
   triggers the problem and v2.6.37.6 does not.

 - Roman Mamedov finds the bug present in Debian 3.1.6-1 (which
   is closely based on stable v3.1.6) and Debian 2.6.37-2 (based on
   stable v2.6.37.2) but not Debian 2.6.37-1 (based on mainline
   v2.6.37).

The regression range described above seems a little inconsistent to
me, so maybe there's something more going on.

Jonathan

[1] http://bugs.debian.org/622325
