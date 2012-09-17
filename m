Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2IQFt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 01:49:57 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53003 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225Ab2IQFtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 01:49:55 -0400
MIME-Version: 1.0
In-Reply-To: <F281D0F91ED19E4D8E63A7504E8A649803C82462@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1347623899-14485-1-git-send-email-kishon@ti.com>
	<F281D0F91ED19E4D8E63A7504E8A649803C82462@039-SN2MPN1-022.039d.mgd.msft.net>
Date: Mon, 17 Sep 2012 11:19:53 +0530
Message-ID: <CAAe_U6KvnXf7v47tVv4LYFUXjKQip7V_1FU6ujqcpoxu8QfMgw@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: phy: add generic PHY framework
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Chen Peter-B29397 <B29397@freescale.com>
Cc: "balbi@ti.com" <balbi@ti.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "alexander.shishkin@linux.intel.com" 
	<alexander.shishkin@linux.intel.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "marex@denx.de" <marex@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 17, 2012 at 6:50 AM, Chen Peter-B29397 <B29397@freescale.com> wrote:
>
>>
>> The PHY framework provides a set of API's for the PHY drivers to
>> create/remove a PHY and the PHY users to obtain a reference to the PHY
>> using or without using phandle. If the PHY users has to obtain a
>> reference to
>> the PHY without using phandle, the platform specfic intialization code
>> (say
>> from board file) should have already called phy_bind with the binding
>> information. The binding information consists of phy's device name, phy
>> user device name and an index. The index is used when the same phy user
>> binds to mulitple phys.
>>
>
> What's an example of "the same phy user binds to multiple phys"?

Single controller using multiple phys..
> I only remembered that Felipe said there are two phy users for one single phy at
> omap5 that is both usb3 and sata uses the same phy.

*index* is used when a single controller uses multiple phys. For
example it could be used for dwc3 (usb3 controller) where it uses usb2
phy and usb3 phy.

Thanks
Kishon
