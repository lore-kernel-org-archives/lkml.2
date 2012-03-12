Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab2CLNYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:24:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49784 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab2CLNYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:24:38 -0400
MIME-Version: 1.0
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CBD666A29@MEP-EXCH.meprolight.com>
References: <CAOMZO5DnP7+zupy9vwBPS0+2XtKM1+nLbwCqBzuCqEG5OWbZRQ@mail.gmail.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD666A28@MEP-EXCH.meprolight.com>
	<CAOMZO5Amo0XFf+TV7PprCL079C5Y0qKmo+k-FfShU7k4SG7W6Q@mail.gmail.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8913@MEP-EXCH.meprolight.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8918@MEP-EXCH.meprolight.com>
	<CAOMZO5A6T+WdOE41Wx6Nctwz9wk8FKaxzjbAt_woZkCnuodNYg@mail.gmail.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD666A29@MEP-EXCH.meprolight.com>
Date: Mon, 12 Mar 2012 10:24:35 -0300
Message-ID: <CAOMZO5B_mZ16zvXdNbKP_PWM5axNPzMeHQttxe8PYHET7UMufg@mail.gmail.com>
Subject: Re: I.MX35 PDK
From: Fabio Estevam <festevam@gmail.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/12, Alex Gershgorin <alexg@meprolight.com> wrote:

> 1. Back resistor 172 to the default value.
>
> 2. Removed the resistor 146, through which a voltage was applied from a PMIC
> (EXT_3V) on "CMOS_VIO".
>
> 3. Connecting a resistor 147 which supplies power from the LDO_3V3 on
> "CMOS_VIO".

The camera on the FSL BSP works fine with no hardware modification on
the mx35pdk.

As I suggested previously you should control the power rails, i2c pad
settings, etc from software so that the camera can also work in
mainline without the need of changing the hardware.

> On my display I see snow flickering and unfortunately not a live video from
> camera.

Do you have this patch applied?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=f910fb8fcd1c97788f2291c8646597bcd87ee061

Also, try to isolate the display from this issue. Capture the image to
a file and try to play it on a PC.

Regards,

Fabio Estevam
