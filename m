Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab1LNTbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:31:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53366 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab1LNTbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:31:05 -0500
MIME-Version: 1.0
In-Reply-To: <20111214073000.GB11024@legolas.emea.dhcp.ti.com>
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
	<1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
	<CAMP44s3Szzm9iXxghXfNCBjKyUw-nRrG1aEeweKnRCidaxmxEA@mail.gmail.com>
	<4EDF5231.6080309@bitmer.com>
	<CAMP44s0a6hcORZn8wDxHUJKxs=wjAmkhRfiT9kEA_MoDYeAmfg@mail.gmail.com>
	<4EE5A8A0.2010206@bitmer.com>
	<CAMP44s1Zz7CqxRM6PeNT3GN9GbCLy+0smgk6_-9kSjghY33Xuw@mail.gmail.com>
	<20111213225308.GB10066@legolas.emea.dhcp.ti.com>
	<CAMP44s3Gmx1M40Dae-RR3+i=vv-d0Ls6h3YToRuUnMTFoqeSCQ@mail.gmail.com>
	<20111214073000.GB11024@legolas.emea.dhcp.ti.com>
Date: Wed, 14 Dec 2011 21:31:01 +0200
Message-ID: <CAMP44s2mcMJ17Yr8gDCdWVpc8Vk2vWYJifMf8a0NAroVawnB+Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Heikki Krogerus <heikki.krogerus@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 9:30 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Dec 14, 2011 at 01:02:09AM +0200, Felipe Contreras wrote:
>> On Wed, Dec 14, 2011 at 12:53 AM, Felipe Balbi <balbi@ti.com> wrote:
>> > patches are welcome
>>
>> The were not last times:
>> http://mid.gmane.org/1288656853-4625-1-git-send-email-felipe.contreras@gmail.com
>
> At least [1] will not apply anymore. Most of that stuff has been cleaned
> up after I introduced the UDC class/core driver. There are still lots of
> things to fix up, but it won't happen overnight. Specially if people are
> more willing to complain than to patch.

Yes, the situation is much better, but these patches still apply on
usb core, or at least the same concept. Anyway, I have the new trivial
patches, I'll send them soon.

> [2] Makes no sense whatsoever. I have been fighting a lot against these
> ARCH dependencies. It's generally used to hide some moronic constructs
> relying on <plat/*> or <mach/*> headers. Most of the time, it's just to
> be able to access e.g. machine_is_*, cpu_is_* or omap_ctrl_read* and the
> like. Also, the first step for having a single ARM zImage is to get rid
> of those ARCH dependencies; we need to be able to compile modules on all
> ARCHes (even x86 for that matter) because:

Read the patch carefully, it doesn't add any new dependencies, it just
shuffles them around, I already explained that. And the rest of the
stuff adds *defaults*, not dependencies, so you can still build in
x86.

> So, if those are the only patches you can provide, please refrain from
> doing so as it will only take time reviewing. Instead, help really
> cleaning up the problems, make sure drivers compile on other ARCHes,
> make sure you don't include <plat/*> or <mach/*> on drivers, make sure
> you help reviewing patches which are coming in.

Some of these changes have already been ack'ed, I just need to split
them. The rest, I guess I have to push it upstairs to Linus so he can
say if it does make sense to make builds more difficult for the users,
and keep the size of the current defconfigs from decreasing.

>> http://mid.gmane.org/1287482608-11320-1-git-send-email-felipe.contreras@gmail.com
>
> "No such article"

It's there. Here's the direct link:
http://article.gmane.org/gmane.linux.kernel/1050608

-- 
Felipe Contreras
