Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab2HaLn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:43:59 -0400
Received: from smtp4.epfl.ch ([128.178.224.218]:49567 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751997Ab2HaLn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:43:58 -0400
From: Philippe =?ISO-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-leds@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>, Donggeun Kim <dg77.kim@samsung.com>,
        Wim Van Sebroeck <wim@iguana.be>, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Anthony Olech <anthony.olech@diasemi.com>
Subject: Re: [PATCH 1/8] mfd: Add Dialog DA906x core driver.
Date: Fri, 31 Aug 2012 13:37:12 +0200
Message-ID: <5755960.24LjLssrFx@laptop>
Organization: EPFL - STI - LSRO1
User-Agent: KMail/4.8.5 (Linux/3.4.9-1.fc16.x86_64; KDE/4.8.5; x86_64; ; )
In-Reply-To: <201208311220@sw-eng-lt-dc-vm2>
References: <201208241445@sw-eng-lt-dc-vm2> <20120825183113.GE6520@opensource.wolfsonmicro.com> <201208311220@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 31 août 2012 12:20:00 Krystian Garbaciak a écrit :
> > On Fri, Aug 24, 2012 at 02:50:00PM +0100, Krystian Garbaciak wrote:
> > > This is MFD module providing access to registers and interrupts of
> > > DA906x
> > > series PMIC. It is used by other functional modules, registered as MFD
> > > cells. Driver uses regmap with paging to access extended register list.
> > > Register map is divided into two pages, where the second page is used
> > > during initialisation.> 
> > Your selection of people to CC here appears both large and random...
> 
> I've added any maintainer for my modules from maintainer list.

You should filter manually what get_maintainer.pl tells you, sometimes it's 
too verbose.

I'm not maintainer of any of the files/tree this patch is touching.

Anyways, it's quite pleasing to see that get_maintainer knows me :)

Regards,

Philippe

