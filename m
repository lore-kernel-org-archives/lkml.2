Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab2LGKkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 05:40:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50995 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab2LGKkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 05:40:22 -0500
Message-ID: <50C1C784.4040209@ti.com>
Date: Fri, 7 Dec 2012 16:10:04 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>
Subject: Re: [PATCH v3 1/3] mtd: nand: omap2: Update nerrors using ecc.strength
References: <1354189595-12784-1-git-send-email-avinashphilip@ti.com> <1354189595-12784-2-git-send-email-avinashphilip@ti.com> <50BF3819.9010200@ti.com> <518397C60809E147AF5323E0420B992E3EA1139B@DBDE01.ent.ti.com>
In-Reply-To: <518397C60809E147AF5323E0420B992E3EA1139B@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/2012 6:13 PM, Philip, Avinash wrote:
> On Wed, Dec 05, 2012 at 17:33:37, Nori, Sekhar wrote:
>> Hi Avinash,
>>
>> On 11/29/2012 5:16 PM, Philip, Avinash wrote:
>>> Update number of errors using nand ecc strength.
>>> Also add macro definitions BCH8_ERROR_MAX & BCH4_ERROR_MAX
>>
>> Can you please describe why the original method of setting nerrors was
>> incorrect? Was it causing any issues in any particular configuration?
> 
> It affects the reusability of the code. For example BCH8 with AM335x RBL 
> compatibility requires  14 bytes instead of 13 byte. So setting nerrors
> with
> 	nerrors = (info->nand.ecc.bytes == 13) ? 8 : 4;
> will break am335x RBL compatibility.

This should be summarized in the patch description so the motivation is
clear to those who read the history later.

Thanks,
Sekhar
