Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab2ARPBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:01:12 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:34879 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab2ARPBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:01:11 -0500
Date: Wed, 18 Jan 2012 16:00:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>, greg@kroah.com,
        eric.piel@tremplin-utc.net, akpm@linux-foundation.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, "Nori, Sekhar" <nsekhar@ti.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Message-ID: <20120118160050.2ad55aad@endymion.delvare>
In-Reply-To: <201201181449.35904.arnd@arndb.de>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com>
	<201201181403.47806.arnd@arndb.de>
	<20120118154344.4187f461@endymion.delvare>
	<201201181449.35904.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012 14:49:35 +0000, Arnd Bergmann wrote:
> On Wednesday 18 January 2012, Jean Delvare wrote:
> > Hi Arnd and all,
> > 
> > The lis3lv02d driver was moved outside of drivers/hwmon to make it
> > clear that we (hwmon/lm-sensors people) are not involved in maintaining
> > this driver in any way. So please remove the lm-sensors list (and
> > myself) from this discussion.
> 
> Ok, I see. What about the applesmc driver then? If we come up with
> a solution that works for the other drivers, should the accelerometer
> part of that be converted to use that interface?

Yes of course.

-- 
Jean Delvare
