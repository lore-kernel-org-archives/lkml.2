Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2FYFj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 01:39:57 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:32795 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176Ab2FYFjz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 01:39:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120623044445.GA2993@kroah.com>
References: <1340370942-23201-1-git-send-email-kishon@ti.com>
	<1340370942-23201-2-git-send-email-kishon@ti.com>
	<20120623044445.GA2993@kroah.com>
Date: Mon, 25 Jun 2012 11:09:54 +0530
Message-ID: <CAAe_U6+dkiQw-i93pFapt6qKrArzaQoE8X3GjDzUDraziG8B2Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/2] drivers: misc: omap: add a new driver for ocp2scp
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, arnd@arndb.de, b-cousson@ti.com, rnayak@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sat, Jun 23, 2012 at 10:14 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Jun 22, 2012 at 06:45:41PM +0530, Kishon Vijay Abraham I wrote:
>> Adds a new driver _ocp2scp_.
>
> That's not what you called this driver in the patch below :(
>
>> This driver takes the responsibility of creating
>> all the devices that is connected to OCP2SCP. In the case of OMAP4, USB2PHY
>> is connected to ocp2scp.
>>
>> This also includes device tree support for ocp2scp driver and
>> the documentation with device tree binding information is updated.
>
> Can't this live where the scp drivers live?  Actually, where is that at?
> Do we have scp drivers?
AFAIK, there isn't any driver for scp. But we have a driver for ocp
and it is present at arch/arm/mach-omap2/omap_l3_noc.c

Thanks
Kishon
