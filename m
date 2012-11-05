Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2KEAdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 19:33:13 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:60909 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2KEAdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 19:33:09 -0500
MIME-Version: 1.0
In-Reply-To: <FED5A9B3-836C-4284-AF61-5D81C65F3634@dominion.thruhere.net>
References: <CA+T6QPk-etCT7EzwGR-tP+JTab_m4Vywh9qgHG_HW-oXKgn_AQ@mail.gmail.com>
 <509391CA.9040408@ti.com> <FED5A9B3-836C-4284-AF61-5D81C65F3634@dominion.thruhere.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 5 Nov 2012 00:32:48 +0000
X-Google-Sender-Auth: 6xCXcS7lWdSVdTgvA9Z8eXyBS-A
Message-ID: <CACxGe6uRMAJNZdip75p46AK4u+ad7=Ry95hdSn168Nqxhaumvg@mail.gmail.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: "Cousson, Benoit" <b-cousson@ti.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Tony Lindgren <tony@atomide.com>, paul@pwsan.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        "Porter, Matt" <mporter@ti.com>, Russ Dill <russ.dill@gmail.com>,
        khilman@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 10:19 AM, Koen Kooi <koen@dominion.thruhere.net> wrote:
>                         button@1 {
>                                 debounce_interval = <50>;
>                                 linux,code = <105>;
>                                 label = "left";
>                                 gpios = <&gpio2 16 0x0>;
>                                 gpio-key,wakeup;
>                                 autorepeat;
>                         };
>
> Is the "linux,code" pure hardware or have there already been exceptions to that rule?

I generally push back on "linux,blah" bindings since they have the
tendency to change over time when someone changes the driver. However,
since the keycodes are part of the Linux userspace ABI, and are
therefore pretty much set it stone, I didn't object to the
linux,keycode binding. There are already drivers using it.

g.
