Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab1EBXgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:36:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56422 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab1EBXgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110502230118.GE28001@n2100.arm.linux.org.uk>
References: <90477150.2231869.1304372815517.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
 <1319927287.2232106.1304373011082.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
 <20110502230118.GE28001@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 2 May 2011 17:36:04 -0600
X-Google-Sender-Auth: KBGLNlg09eGBu_aljF-LSBtOxdo
Message-ID: <BANLkTim4PFNbnD2LwZRwNKTQLiuNpGjrBw@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] ARM: Xilinx: Adding Xilinx board support
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: johnlinn@comcast.net, Arnd Bergmann <arnd@arndb.de>,
        nicolas pitre <nicolas.pitre@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        john linn <john.linn@xilinx.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 5:01 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, May 02, 2011 at 09:50:11PM +0000, johnlinn@comcast.net wrote:
>> Seems easy enough assuming we don't need the SCU early for the core count
>> and can get that from the device tree.
>
> Beware.  Things may not be that trivial when you start considering some
> of the weirdnesses that some vendors start coming out with.
>
>> Since the SCU and part of the GIC end up in the same 4K page they need to be
>> together (unless I'm thinking about that wrong).
>>
>> SCU 0xF8000000
>> GIC_CPU 0xF8000100
>> GIC_DIS 0xF8001000
>
> It is preferable to use the same mapping, as it ensures that you're not
> going to create incompatible aliases.
>
> But, before we get too bogged down with this, please realise that it is
> possible to setup early mappings from the device tree for things like the
> SCU.  Maybe not using ioremap(), but I'm sure we can find some way to use
> the iotable_init() stuff to setup some early mappings from DT for this
> stuff.

absolutely.

g.
