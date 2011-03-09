Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1CIKl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 05:41:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39943 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab1CIKl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 05:41:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wang Lei <f3d27b@gmail.com>
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
Date: Wed, 9 Mar 2011 11:41:28 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
In-Reply-To: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103091141.28396.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 09, 2011, Wang Lei wrote:
> Hi, hackers!
> 
> I have ever reported some bugs, always got kind help, even though one
> thing is not fixed yet, leaving my SBx00 sound card no voice.
> 
> Recently, i encounter another problem, after startup all fans keep
> running. I guess it's a bug. I first saw this at v2.6.38-rc7. It still
> exists at v2.6.38-rc8. The version I'm running now, v2.6.38-rc6+, is OK.
> 
> I cat /sys/class/thermal/thermal_zone0/trip_point_*_temp at the latest
> v2.6.38-rc8, get this output:
> 
> [~]$ cat /sys/class/thermal/thermal_zone0/trip_point_*_temp
> 105000
> 15900
> 15900
> 15900
> 15900
> 15900
> [~]$ 
> 
> This is the output at v2.6.38-rc6+:
> 
> [~]$ cat /sys/class/thermal/thermal_zone0/trip_point_*_temp
> 105000
> 95000
> 75000
> 65000
> 55000
> 40000
> [~]$
> 
> Any help is appreciated.

There was only one commit in that area since 2.6.38-rc6, but it shouldn't
affect the functionality this way.

Is yout thermal management controlled by ACPI?

Rafael
