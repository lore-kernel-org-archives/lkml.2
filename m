Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab1FQJCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:02:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41899 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab1FQJCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:02:22 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: "Girdwood, Liam" <lrg@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH v4 00/18] MFD/ASoC/Input: TWL4030/TWL60X0 changes
Date: Fri, 17 Jun 2011 13:06:19 +0300
Message-ID: <5715729.tcDIHNc8b8@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tony, Samuel, Mark, Liam.

Did you got time to check the patches for your areas?
I want to send the updated series with the change in the vibra driver 
(addressing comments from Dmitry, and Tejun), but I want to address your 
comments as well at the same time if any (or add you Ack).

Thank you,
Péter


On Friday 10 June 2011 13:54:18 Ujfalusi, Peter wrote:
> Hello,
> 
> Changes since v3:
> - patches generated with git format-patch -M to handle renames better
> - Included depending updates for twl6040 soc codec driver:
>  - HS ramp configuration, new ABE dais, updated sample rate constraints
> - Configure the twl6040 codec on SDP4430 board
> 
> Updated intro message from the v3 series:
> The series will do five major things, and they are in one series, because
> they pretty much depending on each other, so it is easier to handle them
> together.
> 
> 1. Move the common pmic related configurations out from the board files.
> New twl-common.c/h file has been created for this purpose.
> OMAP3 board files received two patches (pdata, and regualtor changes), OMAP4
> board files has been changed with one patch.
> 
> 2. Rename the twl4030-codec MFD driver to twl4030-audio
> Since the ASoC multicomponent introduction (2.6.37) the twl4030-codec MFD
> dirver had been using twl4030-audio to register (twl4030-codec is the ASoC
> codec driver). The documentation refers to this part of twl as audio block,
> so it is better to rename the driver as well to avoid confusion.
> 
> 3. Introduction of MFD driver for twl6040.
> The TWL6040 audio IC has codec and vibra functionality.
> Convert the existing ASoC codec driver to use the new MFD driver's
> interface.
> 
> 4. Vibrator driver for TWL6040 (Input/ForceFeedback driver)
> The driver itself, and support for the vibrators in SDP4430 board.
> 
> 5. Updates for twl6040 ASoC codec driver
> HS ramp configuration, new ABE dais, updated sample rate constraints,
> SDP4430 configuration.
> 
> Regards,
> Peter

