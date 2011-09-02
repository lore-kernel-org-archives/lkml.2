Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1IBM4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:56:53 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:47669 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047Ab1IBM4u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:56:50 -0400
From: Mohamed TABET <mohamed.tabet@st.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>, James Morris <jmorris@namei.org>,
        "joe@perches.com" <joe@perches.com>, matt mooney <mfm@muteddisk.com>,
        Sean NEWTON <sean.newton@st.com>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>,
        Christophe Henri RICARD <christophe-h.ricard@st.com>
Date: Fri, 2 Sep 2011 14:55:56 +0200
Subject: RE: [PATCH 1/1] TPM: new stm i2c device driver
Thread-Topic: [PATCH 1/1] TPM: new stm i2c device driver
Thread-Index: AcxjWECs6vp6JCnkQ2OV0TnnQjsuvQAAYICwAYRlm8A=
Message-ID: <8F888FAFF364DD4D9683684315E0207DD25D3AE83B@SAFEX1MAIL3.st.com>
References: <0B9F1C5B86169C4EA9D042C251022E491060F260A1@SAFEX1MAIL3.st.com>
 <0B9F1C5B86169C4EA9D042C251022E4922E010E857@SAFEX1MAIL3.st.com>
 <8F888FAFF364DD4D9683684315E0207DD25D1F05CC@SAFEX1MAIL3.st.com>
 <4E569A0F.40601@linux.vnet.ibm.com>
 <0B9F1C5B86169C4EA9D042C251022E4922E010E8E0@SAFEX1MAIL3.st.com>
In-Reply-To: <0B9F1C5B86169C4EA9D042C251022E4922E010E8E0@SAFEX1MAIL3.st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: CjX/ Iimp Ix/S Jf9i K0yP Pt8B P1dM VaDJ dU4A eh9K g7De
 hWuz nt94 y0yX ABXvjw==
 AB1z1g==;6;agBtAG8AcgByAGkAcwBAAG4AYQBtAGUAaQAuAG8AcgBnADsAagBvAGUAQABwAGUAcgBjAGgAZQBzAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbQAuAHMAZQBsAGgAbwByAHMAdABAAHMAaQByAHIAaQB4AC4AYwBvAG0AOwBtAGYAbQBAAG0AdQB0AGUAZABkAGkAcwBrAC4AYwBvAG0AOwBzAHIAYQBqAGkAdgBAAGwAaQBuAHUAeAAuAHYAbgBlAHQALgBpAGIAbQAuAGMAbwBtAA==;Sosha1_v1;7;{DCBE0A14-55A8-420F-992B-6129891820C8};bQBvAGgAYQBtAGUAZAAuAHQAYQBiAGUAdABAAHMAdAAuAGMAbwBtAA==;Fri,
 02 Sep 2011 12:30:43
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgADEALwAxAF0AIABUAFAATQA6ACAAbgBlAHcAIABzAHQAbQAgAGkAMgBjACAAZABlAHYAaQBjAGUAIABkAHIAaQB2AGUAcgA=
x-cr-puzzleid: {DCBE0A14-55A8-420F-992B-6129891820C8}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Team,

Could I then consider that nothing more prevent ST TPM I2C driver to be posted and made publicly available to kernel.org community?

Regards,
M.Tabet
STMicroelectronics

-----Original Message-----
From: Christophe Henri RICARD
Sent: 25 August, 2011 21:05
To: Rajiv Andrade; Mohamed TABET
Cc: Marcel Selhorst; linux-kernel@vger.kernel.org; James Morris; joe@perches.com; matt mooney; Sean NEWTON; Jean-Luc BLANC
Subject: RE: [PATCH 1/1] TPM: new stm i2c device driver

The 1/3 was placed by accident. I did reply on this one to make sure everybody would be able to do the follow up.
Just did the correction.

Thanks
Christophe
> -----Original Message-----
> From: Rajiv Andrade [mailto:srajiv@linux.vnet.ibm.com]
> Sent: Thursday, August 25, 2011 1:53 PM
> To: Mohamed TABET
> Cc: Marcel Selhorst; linux-kernel@vger.kernel.org; James Morris;
> joe@perches.com; matt mooney; Christophe Henri RICARD; Sean NEWTON;
> Jean-Luc BLANC
> Subject: Re: [PATCH 1/3] TPM: new stm i2c device driver
>
> On 25-08-2011 12:00, Mohamed TABET wrote:
> > Dear Kernel.org recipients,
> >
> > ST will very much appreciate any comments, recommendations or
> suggestions on how to successfully complete this driver submission
> which was pushed on to the kernel.org organization since months now ?
> >
> > Thanks advance for your feedback so that we could move forward and
> eventually address any concern you may still have and that prevent the
> publication of the driver source code to happen.
> Was the 1/3 placed there by accident? If not, were the 2/3 and 3/3
> patches submitted?
>
> Thanks,
> Rajiv
>
> > Best regards,
> > M.Tabet
> >
> > -----Original Message-----
> > From: Christophe Henri RICARD
> > Sent: 25 August, 2011 16:34
> > To: Rajiv Andrade; Marcel Selhorst
> > Cc: James Morris; linux-kernel@vger.kernel.org; joe@perches.com; matt
> mooney; Sean NEWTON; Serge FRUHAUF; Mohamed TABET; Jean-Luc BLANC;
> Christophe DELAUNAY; Tom BOCCHINO; Christophe Henri RICARD; Mathias
> LEBLANC
> > Subject: RE: [PATCH 1/3] TPM: new stm i2c device driver
> >
> > Hi,
> >
> > I would like to know where does this driver submission stand.
> > Do I still have to do any improvements ? Do you need more information
> before pushing it on the main kernel stream ?
> >
> > Thanks for your help.
> > Christophe
> >> -----Original Message-----
> >> From: Christophe Henri RICARD
> >> Sent: Monday, January 17, 2011 5:34 PM
> >> To: Rajiv Andrade; Marcel Selhorst
> >> Cc: James Morris; linux-kernel@vger.kernel.org; joe@perches.com;
> matt
> >> mooney; Sean NEWTON; Serge FRUHAUF; Mohamed TABET; Jean-Luc BLANC;
> >> Christophe DELAUNAY; Tom BOCCHINO; Christophe Henri RICARD
> >> Subject: [PATCH 1/3] TPM: new stm i2c device driver
> >>
> >> Hello Rajiv, James,
> >>
> >> As a new year is here, I'm cleaning up some stuff that were kept on
> the
> >> shelves.
> >> Please find below in a plain text format, the updated tpm stm
> st19np18
> >> i2c driver.
> >> This patch provide in one part the full tpm driver for st19np18
> using
> >> i2c protocol.
> >> The updates are:
> >> - some code/comment cleaning.
> >> - replace wait_event_interruptible_on_gpio function with
> wait_for_stat
> >> (as found in tpm_tis).
> >> This move the duration
> >> (which is different to timeout according TCG PC Client Specific TPM
> >> Interface Specification (TIS) spec:
> >> http://www.trustedcomputinggroup.org/files/resource_files/87BCE22B-
> >> 1D09-3519-ADEBA772FBF02CBD/TCG_PCClientTPMSpecification_1-20_1-
> >> 00_FINAL.pdf) management to the tpm.c to the tpm_transmit function
> in
> >> tpm.c.
> >> I believe, it makes the driver more similar and easier to understand
> >> for everybody (I guess).
> >> - I have tried to take care of my English spelling in some comments
> and
> >> in the documentation file.
> >> - I have updated/replaced the ioctl function by unlocked_ioctl to
> avoid
> >> any warning from the Linux TSS trousers (tcsd) and according to the
> >> 2.6.35 --> 2.6.36 ioctl mechanism delta.
> >>
> >> I have applied this patch to the last security-next kernel as you
> >> mentioned below (2.6.37 rc3) and run it on a beagleboard xM and C4
> >> http://beagleboard.org/.
> >> Those devices are already in the market.
> >>
> >> I've tried to take care of all your feedbacks and to be familiar as
> >> good as I can
> >> with all the Linux guidelines for all the patches submission
> process.
> >> I'm using Outlook as mail client for company policy rules reasons.
> >>
> >> I would like to know also what is the gap I have to reach to get
> this
> >> driver on the kernel source tree.
> >>
> >> Any feedback or comments are welcome.
> >>
> >> Thanks
> >> Christophe
> >>
> >> ------------------------------
> >> Signed-off-by: Christophe RICARD <christophe-h.ricard[at]st.com>
> >> diff --git a/Documentation/tpm/tpm_stm_st19_i2c.txt
> >> b/Documentation/tpm/tpm_stm_st19_i2c.txt
> >> --- a/Documentation/tpm/tpm_stm_st19_i2c.txt  1969-12-31
> >> 17:00:00.000000000 -0700
> >> +++ b/Documentation/tpm/tpm_stm_st19_i2c.txt  2011-01-17
> >> 04:54:13.534658985 -0600
> >> @@ -0,0 +1,169 @@
> >> +/*
> >> + * STMicroelectronics TPM I2C Linux driver for TPM ST19NP18
> >> + * Copyright (C) 2009, 2010 STMicroelectronics
> >> + * This program is free software; you can redistribute it and/or
> >> modify
> >> + * it under the terms of the GNU General Public License as
> published
> >> by
> >> + * the Free Software Foundation; either version 2 of the License,
> or
> >> + * (at your option) any later version.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public
> License
> >> along
> >> + * with this program; if not, write to the Free Software
> Foundation,
> >> Inc.,
> >> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> >> + *
> >> + * STMicroelectronics version 1.2.0, Copyright (C) 2010
> >> + * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> >> + * This is free software, and you are welcome to redistribute it
> >> + * under certain conditions.
> >> + *
> >> + * @Author: Christophe RICARD tpmsupport@st.com
> >> + */
> >> +
> >> +PURPOSE OF THE DOCUMENT
> >> +------------------------
> >> +This document describe the installation of the TPM driver for
> >> +TPM ST19NP18 using I2C protocols.
> >> +
> >> +
> >> +PLATFORM USED FOR TESTING
> >> +--------------------------
> >> +During the development, several embedded platforms running ARM CPU
> >> were
> >> +used.
> >> +Listing of validated platforms:
> >> +- TI Beagleboard
> >> +- STMicroelectronics Spear 300
> >> +- STMicroelectronics Spear 600
> >> +
> >> +REQUIREMENTS
> >> +-------------
> >> +Software
> >> +=========
> >> +The TPM driver can be install under a kernel that implements at
> least
> >> the
> >> +following features:
> >> +- Linux GENERIC_GPIO programming interfaces.
> >> +- I2C new style programming interface base (with probe & remove
> >> functions).
> >> +- 1 I2C adapter (I2C Linux controller driver) or use of I2C_GPIO
> >> driver for I2C
> >> +bitbanging.
> >> +
> >> +
> >> +Hardware
> >> +=========
> >> +To run a TPM, the platform needs at least:
> >> +- 2 Power supplies (3.3V).
> >> +- 1 I2C controller or 2 GPIOs used for SDA & SCL (I2C bit bang
> >> method).
> >> +- 2 GPIOs for signals accept_command & data_available.
> >> +
> >> +TPM I2C speed is 100Khz (Maximum)
> >> +
> >> +All TPM signals work at 3.3V
> >> +
> >> +HOW TO INSTALL
> >> +---------------
> >> +Platform installation file
> >> +===========================
> >> +(N.B: platform file in arch/<processor_type>/mach-<platform-name>/
> >> +
> >> +
> >> +1 - Software integration
> >> +=========================
> >> +<processor_type> could be: alpha, arm, avr32, blackfin, cris, frv,
> >> h8300, ia64,
> >> +m32r, m68k, m68knommu, parisc, powerpc, s390, sh, sparc, sparc64,
> um,
> >> x86,
> >> +xtensa...
> >> +<platform-name> corresponds to your platform
> >> +
> >> +In the file where the machine_init() function exists, the developer
> >> must
> >> +declare:
> >> +- 1 struct st19np18_platform_data to provide which gpio the driver
> >> will use.
> >> +     * The accept_pin and data_avail_pin gpio are configured as
> input
> >> only.
> >> +     * This gpio management is under the platform developer's
> >> responsability.
> >> +
> >> +Finally, in the machine_init() function provided in the same file,
> the
> >> developer
> >> +should use the well known function i2c_register_board_info() from
> the
> >> I2C Linux
> >> +API Core.
> >> +
> >> +2- Hardware integration
> >> +========================
> >> +- ST recommends connecting VPS1 and VPS2 to the board power supply
> and
> >> at least two
> >> +GNDs (on each side of TSSOP28 package). (See datasheet for further
> >> information)
> >> +
> >> +- As the ST19NP18 has no internal pull up, ST recommands having:
> >> +  * 2 external pull up on SDA & SCL signals (RpSDA/RpSCL) with
> values
> >> according
> >> +to the abacus on page 40 or the "I2C Bus specification, version 2.1
> >> January
> >> +2000".
> >> +
> >> +
> >> +Platform integration advises
> >> +=============================
> >> +
> >> +For power management purposes, the kernel will send a TPM_SaveState
> >> command in the
> >> +suspend tpm driver function.
> >> +If the platform generates a TPM Init event on wakeup, the
> >> TPM_Startup(ST_STATE) command should
> >> +be executed before the Linux kernel come up (resume function
> >> execution).
> >> +
> >> +Here is an example with beagleboard:
> >> +====================================
> >> +In the corresponding platform init file, the developer should
> specify
> >> +the following information:
> >> +- The platform gpio's used to managed the tpm's
> >> accept_pin/data_avail_pin
> >> +(in a struct st19np18_platform_data declaration).
> >> +- The TPM I2C 7 bits address (TPM_I2C_ST19_ADDR_WR) (in a struct
> >> i2c_board_info).
> >> +
> >> +Then the developer should add the TPM slave device to the good i2c
> >> adapter with the
> >> +i2c_register_board_info function (assuming that the gpio and the
> i2c
> >> bus are well configured).
> >> +
> >> +Note: For the beagleboard configure your kernel with the following
> >> option: CONFIG_OMAP_MUX=y
> >> +
> >> +file arch\arm\mach-omap2\board-omap3beagle.c
> >> +add the following:
> >> +-------------------------------------------------------------------
> ---
> >> -
> >> +
> >> +static struct st19np18_platform_data tpm_data = {
> >> +        .accept_pin = 135,
> >> +        .data_avail_pin = 143,
> >> +};
> >> +
> >> +static struct i2c_board_info __initdata tpm_st19_i2c_board_info[] =
> {
> >> +        {
> >> +         I2C_BOARD_INFO(TPM_DRIVER_NAME, TPM_I2C_ST19_ADDR_WR),
> >> +         .platform_data = &tpm_data,
> >> +         },
> >> +};
> >> +
> >> +-------------------------------------------------------------------
> ---
> >> --
> >> +Then complete the beagleboard init to be like this:
> >> +-------------------------------------------------------------------
> ---
> >> --
> >> +static void __init omap3_beagle_init(void)
> >> +{
> >> +        omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
> >> +        omap3_beagle_i2c_init();
> >> +        platform_add_devices(omap3_beagle_devices,
> >> +                        ARRAY_SIZE(omap3_beagle_devices));
> >> +        omap_serial_init();
> >> +
> >> +        omap_mux_init_gpio(170, OMAP_PIN_INPUT);
> >> +        gpio_request(170, "DVI_nPD");
> >> +        /* REVISIT leave DVI powered down until it's needed ... */
> >> +        gpio_direction_output(170, true);
> >> +
> >> +        usb_musb_init(&musb_board_data);
> >> +        usb_ehci_init(&ehci_pdata);
> >> +        omap3beagle_flash_init();
> >> +
> >> +        beagle_display_init();
> >> +
> >> +        /* Ensure SDRC pins are mux'd for self-refresh */
> >> +        omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
> >> +        omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
> >> +        omap_mux_init_gpio(((struct st19np18_platform_data *)
> >> +
> tpm_st19_i2c_board_info[0].platform_data)-
> >>> data_avail_pin,
> >> +                           OMAP_PIN_INPUT);
> >> +     omap_mux_init_gpio(((struct st19np18_platform_data *)
> >> +
> tpm_st19_i2c_board_info[0].platform_data)-
> >>> accept_pin,
> >> +                           OMAP_PIN_INPUT);
> >> +
> >> +     i2c_register_board_info(2, tpm_st19_i2c_board_info,
> >> ARRAY_SIZE(tpm_st19_i2c_board_info));
> >> +}
> >> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> >> --- a/drivers/char/tpm/Kconfig        2011-01-06 04:44:39.000000000
> -0600
> >> +++ b/drivers/char/tpm/Kconfig        2011-01-13 22:44:42.906408085
> -0600
> >> @@ -60,4 +60,13 @@
> >>         Further information on this driver and the supported
> hardware
> >>         can be found at http://www.trust.rub.de/projects/linux-
> device-
> >> driver-infineon-tpm/
> >>
> >> +config TCG_ST19_I2C
> >> +        tristate "STMicroelectronics ST19 I2C TPM"
> >> +        depends on I2C
> >> +        depends on GPIOLIB
> >> +        ---help---
> >> +        If you have a TPM security chip from STMicroelectronics
> >> working with
> >> +        an I2C bus, say Yes and it will be accessible from within
> >> Linux.
> >> +        To compile this driver as a module, choose M here; the
> module
> >> will be
> >> +        called tpm_stm_st19_i2c.
> >>  endif # TCG_TPM
> >> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> >> --- a/drivers/char/tpm/Makefile       2011-01-06 04:44:39.000000000
> -0600
> >> +++ b/drivers/char/tpm/Makefile       2011-01-13 22:44:35.506658670
> -0600
> >> @@ -9,3 +9,4 @@
> >>  obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
> >>  obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
> >>  obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
> >> +obj-$(CONFIG_TCG_ST19_I2C) += tpm_stm_st19_i2c.o
> >> diff --git a/drivers/char/tpm/tpm_stm_st19_i2c.c
> >> b/drivers/char/tpm/tpm_stm_st19_i2c.c
> >> --- a/drivers/char/tpm/tpm_stm_st19_i2c.c     1969-12-31
> 17:00:00.000000000
> >> -0700
> >> +++ b/drivers/char/tpm/tpm_stm_st19_i2c.c     2011-01-16
> 22:44:58.466479759
> >> -0600
> >> @@ -0,0 +1,602 @@
> >> +/*
> >> + * STMicroelectronics TPM I2C Linux driver for TPM ST19NP18
> >> + * Copyright (C) 2009, 2010  STMicroelectronics
> >> + *
> >> + * This program is free software; you can redistribute it and/or
> >> modify
> >> + * it under the terms of the GNU General Public License as
> published
> >> by
> >> + * the Free Software Foundation; either version 2 of the License,
> or
> >> + * (at your option) any later version.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public
> License
> >> along
> >> + * with this program; if not, write to the Free Software
> Foundation,
> >> Inc.,
> >> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> >> + *
> >> + * STMicroelectronics version 1.2.0, Copyright (C) 2010
> >> + * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> >> + * This is free software, and you are welcome to redistribute it
> >> + * under certain conditions.
> >> + *
> >> + * @Author: Christophe RICARD tpmsupport@st.com
> >> + *
> >> + * @File: tpm_stm_st19_i2c.c
> >> + *
> >> + * @Synopsis:
> >> + * ----------------------------------------------------------------
> ---
> >> ---
> >> + *   02/12/2008
> >> + *   - Stand alone implementation (without any TPM api)
> >> + * ----------------------------------------------------------------
> ---
> >> ---
> >> + *   03/02/2010
> >> + *   - Power management (suspend and resume functions)
> >> + *   implementation
> >> + * ----------------------------------------------------------------
> ---
> >> ---
> >> + *   03/19/2010
> >> + *   - Use of the linux kernel TPM api --> driver/char/tpm
> >> + * ----------------------------------------------------------------
> ---
> >> ---
> >> + *   05/26/2010
> >> + *   - Update code for code submission and bug fixes:
> >> + *   - Comments spelling fixes
> >> + *   - Lindent script execution
> >> + *   - checkpatch.pl script execution
> >> + *   - fix syslog error when loaded as a module:
> >> + *    "release() function missing and must be fixed"
> >> + *   - name files change from
> >> + *     stm_st19_tpm_i2c to tpm_stm_st19_i2c
> >> + * ----------------------------------------------------------------
> ---
> >> ---
> >> + *   06/15/2010
> >> + *   - Update for new tpm core device.
> >> + *   num_opens --> is_open
> >> + * ----------------------------------------------------------------
> ---
> >> ---
> >> + *   07/08/2010
> >> + *   - Update probe, resume suspend functions
> >> + *   - Fix issue suspend buffer and work around related to the
> >> + *   chip->data_buffer not allocated.
> >> + * ----------------------------------------------------------------
> ---
> >> ---
> >> + *   09/03/2010
> >> + *   - Review under LKLM
> >> + *   - Patches from Joe Perches after review which fix some break
> and
> >> + *   some neatings.
> >> + * ----------------------------------------------------------------
> ---
> >> ---
> >> + *   09/16/2010
> >> + *   - Remove unaccurate comment.
> >> + * ----------------------------------------------------------------
> ---
> >> ---
> >> + *   01/12/2011
> >> + *   - update ioctl function to unlocked_ioctl for kernel >= 2.6.36
> >> + *   - Some cleaning
> >> + */
> >> +
> >> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >> +
> >> +#include <linux/module.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/delay.h>
> >> +#include <linux/init.h>
> >> +#include <linux/i2c.h>
> >> +#include <linux/i2c-id.h>
> >> +#include <linux/wait.h>
> >> +#include <linux/string.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/spinlock.h>
> >> +#include <linux/sysfs.h>
> >> +#include <linux/gpio.h>
> >> +#include <linux/sched.h>
> >> +#include <linux/uaccess.h>
> >> +#include <linux/io.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/version.h>
> >> +#include <linux/smp_lock.h>
> >> +
> >> +#include <linux/i2c/tpm_stm_st19_i2c.h>
> >> +
> >> +#include "tpm.h"
> >> +
> >> +#include "tpm_stm_st19_i2c.h"
> >> +
> >> +#ifdef DEBUG
> >> +#define FUNC_ENTER() pr_info("%s\n", __func__)
> >> +#else
> >> +#define FUNC_ENTER() do {} while (0)
> >> +#endif
> >> +
> >> +static struct st19np18_platform_data *pin_infos;
> >> +
> >> +#define TPM_STS_DATA_AVAIL 0x10
> >> +#define TPM_STS_ACCEPT_COMMAND 0x01
> >> +#define TPM_STS_CANCEL (TPM_STS_DATA_AVAIL |
> TPM_STS_ACCEPT_COMMAND)
> >> +enum tis_defaults {
> >> +     TIS_SHORT_TIMEOUT = 750,        /* ms */
> >> +     TIS_LONG_TIMEOUT = 2000,        /* 2 sec */
> >> +};
> >> +
> >> +/*
> >> + * gpio_readpin is a wrapper to read a gpio value.
> >> + * Use generic gpio APIs
> >> + * @param: pin_id, the pin identifier where the value will be read.
> >> + * @return: the gpio value (should be 0 or 1) or negative errno
> >> + */
> >> +static int gpio_readpin(int pin_id)
> >> +{
> >> +     int ret;
> >> +     ret = gpio_direction_input(pin_id);
> >> +     if (ret == 0)
> >> +             return gpio_get_value(pin_id);
> >> +     return ret;
> >> +}
> >> +
> >> +/*
> >> + * tpm_stm_i2c_status is not implemented because TIS registers are
> not
> >> + * implemented.
> >> + */
> >> +static u8 tpm_stm_i2c_status(struct tpm_chip *chip)
> >> +{
> >> +     u8 state_data, state_command;
> >> +
> >> +     state_data = gpio_readpin(pin_infos->data_avail_pin);
> >> +     state_command = gpio_readpin(pin_infos->accept_pin);
> >> +     return (state_data << 4) | state_command;
> >> +}
> >> +
> >> +static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned
> long
> >> timeout,
> >> +                      wait_queue_head_t *queue)
> >> +{
> >> +     unsigned long stop;
> >> +     u8 status;
> >> +
> >> +     FUNC_ENTER();
> >> +
> >> +     /* check current status */
> >> +     status = tpm_stm_i2c_status(chip);
> >> +     if (status == mask)
> >> +             return 0;
> >> +     if (status == TPM_STS_CANCEL)
> >> +             goto end;
> >> +     stop = jiffies + timeout;
> >> +     do {
> >> +             msleep(TPM_TIMEOUT);
> >> +             status = tpm_stm_i2c_status(chip);
> >> +             if ((status & mask) == mask)
> >> +                     return 0;
> >> +     } while (time_before(jiffies, stop));
> >> +end:
> >> +     return -ETIME;
> >> +}
> >> +
> >> +/*
> >> + * tpm_stm_i2c_send send TPM commands through the I2C bus.
> >> + * Before sending any TPM commands, tpm_stm_i2c_send poll
> >> data_available and
> >> + * accept_command TPM GPIOs.
> >> + *
> >> + * In case the data_available is high (logical value 1),
> >> tpm_stm_i2c_send will
> >> + * empty the TPM FIFO by reading all the datas stored inside the
> TPM.
> >> + *
> >> + * Then, if the accept_command TPM GPIO is high(logical value 1)
> >> + * tpm_stm_i2c_send will first send the 10 bytes header of the TCG
> >> commands and
> >> + * then send the others bytes by 40 bytes blocks.
> >> + *
> >> + * data_available and accept_command TPM GPIOs will goes low when
> the
> >> TPM
> >> + * compute the command.
> >> + *
> >> + * @param: chip, the tpm_chip description as specified in
> >> driver/char/tpm/tpm.h.
> >> + * @param: buf,      the buffer to send.
> >> + * @param: count, the number of bytes to send.
> >> + * @return: In case of success the number of bytes sent.
> >> + *                   In other case, a < 0 value describing the
> issue.
> >> + */
> >> +static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char
> *buf,
> >> +                         size_t count)
> >> +{
> >> +     u32 ret = 0, i, size, ordinal;
> >> +     struct i2c_client *client;
> >> +
> >> +     FUNC_ENTER();
> >> +
> >> +     if (chip == NULL)
> >> +             return -EBUSY;
> >> +     if (count < TPM_HEADER_SIZE)
> >> +             return -EBUSY;
> >> +     client = (struct i2c_client *)pin_infos->client;
> >> +
> >> +     ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
> >> +
> >> +     size = TPM_HEADER_SIZE;
> >> +     i = 0;
> >> +     while (i < size && wait_for_stat(chip, TPM_STS_ACCEPT_COMMAND,
> >> +                                      TPM_I2C_SHORT,
> >> +                                      &chip->vendor.int_queue) ==
> 0) {
> >> +             int bytes;
> >> +
> >> +             if (i == 0)
> >> +                     bytes = TPM_HEADER_SIZE;
> >> +             else
> >> +                     bytes = min_t(int, count - i,
> TPM_I2C_BLOCK_SIZE);
> >> +
> >> +             if (i == 0) {
> >> +                     size = be32_to_cpu(*(__be32 *) (buf + 2));
> >> +                     size = size < count ? size : count;
> >> +             }
> >> +             if (count < TPM_HEADER_SIZE)
> >> +                     bytes = count;
> >> +             ret = i2c_master_send(client, buf + i, bytes);
> >> +             if (ret < 0) {
> >> +                     pr_info("Failed to send data\n");
> >> +                     goto end;
> >> +             }
> >> +
> >> +             if (i == 0)
> >> +                     i += TPM_HEADER_SIZE;
> >> +             else
> >> +                     i += TPM_I2C_BLOCK_SIZE;
> >> +     }
> >> +
> >> +     if (i == 0) {
> >> +             pr_info("Failed to read gpio pin (AcceptCmd)\n");
> >> +             ret = -EIO;
> >> +     }
> >> +end:
> >> +     return ret ? ret : count;
> >> +}
> >> +
> >> +/*
> >> + * tpm_stm_i2c_recv received TPM response through the I2C bus.
> >> + * Before receiving any TPM response, tpm_stm_i2c_recv poll
> >> data_available and
> >> + * accept_command TPM GPIOs.
> >> + *
> >> + * In case the accept_command is high (logical value 1),
> >> tpm_stm_i2c_recv will
> >> + * do nothing.
> >> + *
> >> + * Then, if the data_available TPM GPIO is high(logical value 1)
> >> + * tpm_stm_i2c_recv will first receive the 10 bytes header of the
> TCG
> >> TPM
> >> + * response and then receive the others bytes by 40 bytes blocks.
> >> + *
> >> + * accept_command TPM GPIOs will goes high when the TPM Fofo is
> empty.
> >> + *
> >> + * @param: chip, the tpm_chip description as specified in
> >> driver/char/tpm/tpm.h.
> >> + * @param: buf,      the buffer to store datas.
> >> + * @param: count, the number of bytes to send.
> >> + * @return: In case of success the number of bytes received.
> >> + *                   In other case, a < 0 value describing the
> issue.
> >> + */
> >> +static int tpm_stm_i2c_recv(struct tpm_chip *chip, unsigned char
> *buf,
> >> +                         size_t count)
> >> +{
> >> +     int ret = 0;
> >> +     int i, size;
> >> +     struct i2c_client *client;
> >> +
> >> +     FUNC_ENTER();
> >> +
> >> +     if (chip == NULL)
> >> +             return -EBUSY;
> >> +     if (count < TPM_HEADER_SIZE)
> >> +             return -EBUSY;
> >> +
> >> +     client = (struct i2c_client *)pin_infos->client;
> >> +
> >> +     size = TPM_HEADER_SIZE;
> >> +     i = 0;
> >> +     while (i < size && wait_for_stat(chip, TPM_STS_DATA_AVAIL,
> >> +                                      TPM_I2C_SHORT,
> >> +                                      &chip->vendor.read_queue) ==
> 0) {
> >> +             int bytes;
> >> +
> >> +             if (count < TPM_HEADER_SIZE)
> >> +                     bytes = count;
> >> +             else if (i == 0)
> >> +                     bytes = TPM_HEADER_SIZE;
> >> +             else
> >> +                     bytes = min_t(int, size - i,
> TPM_I2C_BLOCK_SIZE);
> >> +
> >> +             ret = i2c_master_recv(client, buf + i, bytes);
> >> +             if (ret < 0) {
> >> +                     pr_info(" Failed to read gpio pin
> >> (DataAvailable)\n");
> >> +                     goto end;
> >> +             }
> >> +
> >> +             if (!buf) {
> >> +                     pr_info("read buffer is NULL\n");
> >> +                     goto end;
> >> +             }
> >> +
> >> +             if (i == 0) {
> >> +                     size = be32_to_cpu(*(__be32 *) (buf + 2));
> >> +                     if (size > count)
> >> +                             size = count;
> >> +                     i += TPM_HEADER_SIZE;
> >> +             } else
> >> +                     i += TPM_I2C_BLOCK_SIZE;
> >> +     }
> >> +
> >> +     if (i == 0) {
> >> +             pr_info("Failed to read gpio pin (DataAvailable)\n");
> >> +             ret = -EIO;
> >> +             goto end;
> >> +     }
> >> +     return size;
> >> +end:
> >> +     return ret;
> >> +}
> >> +
> >> +/*
> >> + * tpm_stm_i2c_cancel, cancel is not implemented.
> >> + * @param: chip, the tpm_chip description as specified in
> >> driver/char/tpm/tpm.h.
> >> + */
> >> +static void tpm_stm_i2c_cancel(struct tpm_chip *chip)
> >> +{
> >> +}
> >> +
> >> +/*
> >> + * tpm_st19_i2c_ioctl provides 2 handles:
> >> + * - TPMIOC_CANCEL: allow to CANCEL a TPM commands execution.
> >> + *   See tpm_stm_i2c_cancel description above
> >> + * - TPMIOC_TRANSMIT: allow to transmit a TPM commands.
> >> + *
> >> + * @return: In case of success, return TPM response size.
> >> + * In other case return < 0 value describing the issue.
> >> + */
> >> +/*#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 36)
> >> +static ssize_t tpm_st19_i2c_ioctl(struct inode *inode, struct file
> >> *file,
> >> +                               unsigned int cmd, unsigned long arg)
> >> +#else*/
> >> +static long tpm_st19_i2c_unlocked_ioctl(struct file *file,
> >> +                                     unsigned int cmd, unsigned
> long arg)
> >> +/*#endif*/
> >> +{
> >> +     int in_size = 0, out_size = 0, ret = -ENOTTY;
> >> +     struct tpm_chip *chip = file->private_data;
> >> +
> >> +     lock_kernel();
> >> +     switch (cmd) {
> >> +     case TPMIOC_CANCEL:
> >> +             tpm_stm_i2c_cancel(chip);
> >> +             ret = -ENOSYS;
> >> +             break;
> >> +     case TPMIOC_TRANSMIT:
> >> +             if (copy_from_user(chip->data_buffer,
> >> +                                (const char *)arg,
> TPM_HEADER_SIZE)) {
> >> +                     ret = -EFAULT;
> >> +                     break;
> >> +             }
> >> +
> >> +             in_size = be32_to_cpu(*(__be32 *) (chip->data_buffer +
> 2));
> >> +             if (copy_from_user(chip->data_buffer,
> >> +                                (const char *)arg, in_size)) {
> >> +                     ret = -EFAULT;
> >> +                     break;
> >> +             }
> >> +
> >> +             tpm_stm_i2c_send(chip, chip->data_buffer, in_size);
> >> +
> >> +             out_size = tpm_stm_i2c_recv(chip, chip->data_buffer,
> >> +                                         TPM_BUFSIZE);
> >> +             if (copy_to_user((char *)arg, chip->data_buffer,
> out_size))
> >> {
> >> +                     ret = -EFAULT;
> >> +                     break;
> >> +             }
> >> +             ret = out_size;
> >> +             break;
> >> +     }
> >> +     unlock_kernel();
> >> +     return ret;
> >> +}
> >> +
> >> +static const struct file_operations tpm_st19_i2c_fops = {
> >> +     .owner = THIS_MODULE,
> >> +     .llseek = no_llseek,
> >> +     .read = tpm_read,
> >> +
> >> +     /*#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 36)
> >> +        .ioctl = tpm_st19_i2c_ioctl,
> >> +        #else */
> >> +     .unlocked_ioctl = tpm_st19_i2c_unlocked_ioctl,
> >> +     /*#endif */
> >> +
> >> +     .write = tpm_write,
> >> +     .open = tpm_open,
> >> +     .release = tpm_release,
> >> +};
> >> +
> >> +static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
> >> +static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
> >> +static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
> >> +static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
> >> +static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
> >> +static DEVICE_ATTR(temp_deactivated, S_IRUGO,
> >> tpm_show_temp_deactivated, NULL);
> >> +static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
> >> +static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL,
> tpm_store_cancel);
> >> +
> >> +static struct attribute *stm_tpm_attrs[] = {
> >> +     &dev_attr_pubek.attr,
> >> +     &dev_attr_pcrs.attr,
> >> +     &dev_attr_enabled.attr,
> >> +     &dev_attr_active.attr,
> >> +     &dev_attr_owned.attr,
> >> +     &dev_attr_temp_deactivated.attr,
> >> +     &dev_attr_caps.attr,
> >> +     &dev_attr_cancel.attr, NULL,
> >> +};
> >> +
> >> +static struct attribute_group stm_tpm_attr_grp = {
> >> +     .attrs = stm_tpm_attrs
> >> +};
> >> +
> >> +static struct tpm_vendor_specific st_i2c_tpm = {
> >> +     .send = tpm_stm_i2c_send,
> >> +     .recv = tpm_stm_i2c_recv,
> >> +     .cancel = tpm_stm_i2c_cancel,
> >> +     .status = tpm_stm_i2c_status,
> >> +     .req_complete_mask = TPM_STS_DATA_AVAIL,
> >> +     .req_complete_val = TPM_STS_DATA_AVAIL,
> >> +     .req_canceled = TPM_STS_CANCEL,
> >> +     .attr_group = &stm_tpm_attr_grp,
> >> +     .miscdev = {.fops = &tpm_st19_i2c_fops,},
> >> +};
> >> +
> >> +/*
> >> + * tpm_st19_i2c_probe initialize the TPM device
> >> + * @param: client, the i2c_client drescription (TPM I2C
> description).
> >> + * @param: id, the i2c_device_id struct.
> >> + * @return: 0 in case of success.
> >> + *                   -1 in other case.
> >> + */
> >> +static int
> >> +tpm_st19_i2c_probe(struct i2c_client *client, const struct
> >> i2c_device_id *id)
> >> +{
> >> +     int err;
> >> +     struct tpm_chip *chip;
> >> +     struct st19np18_platform_data *platform_data;
> >> +
> >> +     FUNC_ENTER();
> >> +
> >> +     err = 0;
> >> +
> >> +     /* Check I2C platform functionnalities */
> >> +     if (client == NULL) {
> >> +             pr_info("client is NULL. exiting.\n");
> >> +             err = -ENODEV;
> >> +             goto end;
> >> +     }
> >> +
> >> +     if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> >> +             pr_info("client not i2c capable\n");
> >> +             err = -ENODEV;
> >> +             goto end;
> >> +     }
> >> +
> >> +     chip = tpm_register_hardware(&client->dev, &st_i2c_tpm);
> >> +     if (!chip) {
> >> +             err = -ENODEV;
> >> +             goto end;
> >> +     }
> >> +
> >> +     platform_data = client->dev.platform_data;
> >> +     pin_infos = platform_data;
> >> +     platform_data->client = client;
> >> +     /* Default timeouts */
> >> +        chip->vendor.timeout_a =
> msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> >> +        chip->vendor.timeout_b =
> msecs_to_jiffies(TIS_LONG_TIMEOUT);
> >> +        chip->vendor.timeout_c =
> msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> >> +        chip->vendor.timeout_d =
> msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> >> +
> >> +     /* Register GPIO pin through generic Linux GPIO API */
> >> +     err = gpio_request(platform_data->accept_pin, "accept
> command");
> >> +     if (err)
> >> +             goto _gpio_init;
> >> +
> >> +     err = gpio_request(platform_data->data_avail_pin, "data
> >> available");
> >> +     if (err)
> >> +             goto _gpio_init;
> >> +
> >> +     tpm_get_timeouts(chip);
> >> +     tpm_continue_selftest(chip);
> >> +
> >> +     /* attach chip datas to client */
> >> +     i2c_set_clientdata(client, chip);
> >> +
> >> +     pr_info("TPM I2C Initialized\n");
> >> +     return 0;
> >> +_gpio_init:
> >> +     if (platform_data) {
> >> +             gpio_free(platform_data->accept_pin);
> >> +             gpio_free(platform_data->data_avail_pin);
> >> +     }
> >> +     tpm_remove_hardware(chip->dev);
> >> +end:
> >> +     i2c_set_clientdata(client, NULL);
> >> +     pr_info("TPM I2C initialisation fail\n");
> >> +     return err;
> >> +}
> >> +
> >> +/*
> >> + * tpm_st19_i2c_remove remove the TPM device
> >> + * @param: client, the i2c_client drescription (TPM I2C
> description).
> >> +             clear_bit(0, &chip->is_open);
> >> + * @return: 0 in case of success.
> >> + */
> >> +static __devexit int tpm_st19_i2c_remove(struct i2c_client *client)
> >> +{
> >> +     struct tpm_chip *chip = (struct tpm_chip
> >> *)i2c_get_clientdata(client);
> >> +     FUNC_ENTER();
> >> +
> >> +     if (pin_infos != NULL) {
> >> +             gpio_free(pin_infos->accept_pin);
> >> +             gpio_free(pin_infos->data_avail_pin);
> >> +     }
> >> +
> >> +     /* Check if chip has been previously clean */
> >> +     if (chip != NULL)
> >> +             tpm_remove_hardware(chip->dev);
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +/*
> >> + * tpm_st19_i2c_pm_suspend suspend the TPM device
> >> + * @param: client, the i2c_client drescription (TPM I2C
> description).
> >> + * @param: mesg, the power management message.
> >> + * @return: 0 in case of success.
> >> + */
> >> +static int tpm_st19_i2c_pm_suspend(struct i2c_client *client,
> >> pm_message_t mesg)
> >> +{
> >> +     return tpm_pm_suspend(&client->dev, mesg);
> >> +}
> >> +
> >> +/*
> >> + * tpm_st19_i2c_pm_resume resume the TPM device
> >> + * @param: client, the i2c_client drescription (TPM I2C
> description).
> >> + * @return: 0 in case of success.
> >> + */
> >> +static int tpm_st19_i2c_pm_resume(struct i2c_client *client)
> >> +{
> >> +     return tpm_pm_resume(&client->dev);
> >> +}                            /* tpm_st19_i2c_pm_resume() */
> >> +
> >> +static const struct i2c_device_id tpm_st19_i2c_id[] = {
> >> +     {TPM_DRIVER_NAME, 0},
> >> +     {}
> >> +};
> >> +
> >> +MODULE_DEVICE_TABLE(i2c, tpm_st19_i2c_id);
> >> +
> >> +static struct i2c_driver tpm_st19_i2c_driver = {
> >> +     .driver = {
> >> +                .owner = THIS_MODULE,
> >> +                .name = TPM_DRIVER_NAME,
> >> +                },
> >> +     .probe = tpm_st19_i2c_probe,
> >> +     .remove = tpm_st19_i2c_remove,
> >> +     .resume = tpm_st19_i2c_pm_resume,
> >> +     .suspend = tpm_st19_i2c_pm_suspend,
> >> +     .id_table = tpm_st19_i2c_id
> >> +};
> >> +
> >> +/*
> >> + * tpm_st19_i2c_init initialize driver
> >> + * @return: 0 if successful, else non zero value.
> >> + */
> >> +static int __init tpm_st19_i2c_init(void)
> >> +{
> >> +     FUNC_ENTER();
> >> +     return i2c_add_driver(&tpm_st19_i2c_driver);
> >> +}
> >> +
> >> +/*
> >> + * tpm_st19_i2c_exit The kernel calls this function during
> unloading
> >> the
> >> + * module or during shut down process
> >> + */
> >> +static void __exit tpm_st19_i2c_exit(void)
> >> +{
> >> +     FUNC_ENTER();
> >> +     i2c_del_driver(&tpm_st19_i2c_driver);
> >> +}
> >> +
> >> +module_init(tpm_st19_i2c_init);
> >> +module_exit(tpm_st19_i2c_exit);
> >> +
> >> +MODULE_AUTHOR("Christophe Ricard (tpmsupport@st.com)");
> >> +MODULE_DESCRIPTION("STM TPM I2C ST19 Driver");
> >> +MODULE_VERSION("1.2.0");
> >> +MODULE_LICENSE("GPL");
> >> diff --git a/drivers/char/tpm/tpm_stm_st19_i2c.h
> >> b/drivers/char/tpm/tpm_stm_st19_i2c.h
> >> --- a/drivers/char/tpm/tpm_stm_st19_i2c.h     1969-12-31
> 17:00:00.000000000
> >> -0700
> >> +++ b/drivers/char/tpm/tpm_stm_st19_i2c.h     2011-01-16
> 22:45:08.918407969
> >> -0600
> >> @@ -0,0 +1,52 @@
> >> +/*
> >> + * STMicroelectronics TPM I2C Linux driver for TPM ST19NP18
> >> + * Copyright (C) 2009, 2010  STMicroelectronics
> >> + *
> >> + * This program is free software; you can redistribute it and/or
> >> modify
> >> + * it under the terms of the GNU General Public License as
> published
> >> by
> >> + * the Free Software Foundation; either version 2 of the License,
> or
> >> + * (at your option) any later version.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public
> License
> >> along
> >> + * with this program; if not, write to the Free Software
> Foundation,
> >> Inc.,
> >> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> >> + *
> >> + * STMicroelectronics version 1.2.0, Copyright (C) 2010
> >> + * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> >> + * This is free software, and you are welcome to redistribute it
> >> + * under certain conditions.
> >> + *
> >> + * @Author: Christophe RICARD tpmsupport@st.com
> >> + *
> >> + * @File: stm_st19_tpm_i2c.h
> >> + *
> >> + * @Date: 02/12/2008
> >> + */
> >> +#ifndef __STM_ST19_TPM_I2C_MAIN_H__
> >> +#define __STM_ST19_TPM_I2C_MAIN_H__
> >> +
> >> +#include <linux/pci.h>
> >> +#include <linux/module.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/i2c.h>
> >> +#include <linux/i2c-id.h>
> >> +#include <linux/fs.h>
> >> +#include <linux/miscdevice.h>
> >> +
> >> +#define TPM_BUFSIZE          2048
> >> +#define TPM_HEADER_SIZE              10
> >> +#define TPM_I2C_BLOCK_SIZE   0x28
> >> +
> >> +#define TPM_I2C_SHORT                2000    /* 2s */
> >> +#define STARTUP_WAIT_INTERVAL        8       /* 8ms */
> >> +
> >> +/* ioctl commands */
> >> +#define TPMIOC_CANCEL                _IO('T', 0x00)  /* Not
> supported */
> >> +#define TPMIOC_TRANSMIT              _IO('T', 0x01)
> >> +
> >> +#endif /* __STM_ST19_TPM_I2C_MAIN_H__ */
> >> diff --git a/include/linux/i2c/tpm_stm_st19_i2c.h
> >> b/include/linux/i2c/tpm_stm_st19_i2c.h
> >> --- a/include/linux/i2c/tpm_stm_st19_i2c.h    1969-12-31
> >> 17:00:00.000000000 -0700
> >> +++ b/include/linux/i2c/tpm_stm_st19_i2c.h    2011-01-16
> >> 22:45:31.758408188 -0600
> >> @@ -0,0 +1,42 @@
> >> +/*
> >> + * STMicroelectronics TPM I2C Linux driver for TPM ST19NP18
> >> + * Copyright (C) 2009, 2010 STMicroelectronics
> >> + * Christophe RICARD tpmsupport@st.com
> >> + * This program is free software; you can redistribute it and/or
> >> modify
> >> + * it under the terms of the GNU General Public License as
> published
> >> by
> >> + * the Free Software Foundation; either version 2 of the License,
> or
> >> + * (at your option) any later version.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public
> License
> >> along
> >> + * with this program; if not, write to the Free Software
> Foundation,
> >> Inc.,
> >> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> >> + *
> >> + * STMicroelectronics version 1.2.0, Copyright (C) 2010
> >> + * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> >> + * This is free software, and you are welcome to redistribute it
> >> + * under certain conditions.
> >> + *
> >> + * @File: stm_st19_tpm_i2c.h
> >> + *
> >> + * @Date: 06/15/2008
> >> + */
> >> +#ifndef __STM_ST19_TPM_I2C_H__
> >> +#define __STM_ST19_TPM_I2C_H__
> >> +
> >> +#include <linux/i2c.h>
> >> +
> >> +#define TPM_DRIVER_NAME         "st19np18"
> >> +#define TPM_I2C_ST19_ADDR_WR (0x26 >> 1) /*0x13 7 bits address */
> >> +
> >> +struct st19np18_platform_data {
> >> +     int accept_pin; /* accept command pin */
> >> +     int data_avail_pin;/* data available pin */
> >> +     struct i2c_client *client;
> >> +};
> >> +
> >> +#endif /* __STM_ST19_TPM_I2C_H__ */
