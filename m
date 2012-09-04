Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab2IDVpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:45:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40198 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab2IDVpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:45:18 -0400
X-AuditID: cbfee61b-b7f056d000002c30-22-5046766c0c01
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, dong.aisheng@linaro.org,
        swarren@wwwdotorg.org, patches@linaro.org
References: <1345720529-32315-1-git-send-email-thomas.abraham@linaro.org>
 <1345720529-32315-2-git-send-email-thomas.abraham@linaro.org>
 <CACRpkdbVe77pAYdOw0+_2G2FWVWcn4GKQty6R-LXXEz-OkUdUg@mail.gmail.com>
 <CAJuYYwTD+vMg=YjUj4G0E-uakk=Y_SD+cUU22QSx0yRC50V75w@mail.gmail.com>
In-reply-to: <CAJuYYwTD+vMg=YjUj4G0E-uakk=Y_SD+cUU22QSx0yRC50V75w@mail.gmail.com>
Subject: RE: [PATCH v3 1/4] pinctrl: add samsung pinctrl and gpiolib driver
Date: Wed, 05 Sep 2012 06:45:16 +0900
Message-id: <226e01cd8ae6$928010b0$b7803210$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2K1iwIrVpIp9OfTYS6/QAqbwJhJwAEDuzw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd3cMrcAg+tzmS0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKaev8zFvzhq3h+5D9jA2MrTxcjJ4eEgInEq6+rmSBs
	MYkL99azgdhCAtMZJa6fq+pi5AKy/zJKXLu8FyzBJqAhcfj9M/YuRg4OEYE4iQW7LEFqmAV6
	mCSaTz9mgWiYziSxetIrRpAGToFgie/zZoFtEBbwlli5+Ak7iM0ioCqxbuVZsDivgK3E2pfX
	GCFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDLJYQkBd4tFfXYgbjCS+d6ZAVIhI7HvxjnEC
	o9AsJINmIRk0C8mgWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDuhn0jsYVzVY
	HGIU4GBU4uFl8HYLEGJNLCuuzD3EKMHBrCTCe3u1a4AQb0piZVVqUX58UWlOavEhRmkOFiVx
	XqdzdgFCAumJJanZqakFqUUwWSYOTqkGRu/sW99zly/R/vZh7uVFS7oNEs+8E5m2qdFGfY3d
	rprsdZOCax9zvuFJaF2W3DshOPPoQ6kjNQwpvofZQ/KWBZn1TjdUX5Sc5MpecaL1hQyv3F4+
	ptaUD2m9p1Q2f/Pn+yUn2JyUPjv1lN6uFMYDU+Qm7bn4pSZry/Vag07uHe/zfx67cGlHkxJL
	cUaioRZzUXEiAPguIx1kAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote:
> 
> On 3 September 2012 16:44, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Thu, Aug 23, 2012 at 1:15 PM, Thomas Abraham
> > <thomas.abraham@linaro.org> wrote:
> >
> >> Add a new device tree enabled pinctrl and gpiolib driver for Samsung
> >> SoC's. This driver provides a common and extensible framework for all
> >> Samsung SoC's to interface with the pinctrl and gpiolib subsystems.
> This
> >> driver supports only device tree based instantiation and hence can be
> >> used only on those Samsung platforms that have device tree enabled.
> >>
> >> This driver is split into two parts: the pinctrl interface and the
> gpiolib
> >> interface. The pinctrl interface registers pinctrl devices with the
> pinctrl
> >> subsystem and gpiolib interface registers gpio chips with the gpiolib
> >> subsystem. The information about the pins, pin groups, pin functions
> and
> >> gpio chips, which are SoC specific, are parsed from device tree node.
> >>
> >> Cc: Linus Walleij <linus.walleij@linaro.org>
> >> Cc: Kukjin Kim <kgene.kim@samsung.com>
> >> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> >
> > Looks good to me, I saw Stephen had some minor comments and
> > I expect that you probably fix them before applying to the Samsung
> > tree so:
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > Feel free to push this through ARM SoC, I guess that's the plan?
> 
> Hi Linus,
> 
> Thanks for reviewing the Samsung pinctrl driver patches. I will do the
> changes that Stephen has listed and resubmit. I will request Samsung
> maintainer to consider the support for pinctrl driver for 3.7.
> 
Looks OK, I will apply updated patches Thomas said into Samsung tree.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

