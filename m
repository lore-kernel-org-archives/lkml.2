Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922Ab0I1Im6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:42:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35886 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab0I1Im5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:42:57 -0400
Date: Tue, 28 Sep 2010 11:42:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "Balbi, Felipe" <balbi@ti.com>, Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>
Subject: Re: [PATCH v4] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20100928084251.GC3900@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1285618704-8985-1-git-send-email-notasas@gmail.com>
 <20100928060554.GF2702@legolas.emea.dhcp.ti.com>
 <AANLkTikZqtXa2YQsDehoWVMRstefUyafsQn2mph7U3CZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikZqtXa2YQsDehoWVMRstefUyafsQn2mph7U3CZ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 03:37:46AM -0500, Grazvydas Ignotas wrote:
>On Tue, Sep 28, 2010 at 9:05 AM, Felipe Balbi <balbi@ti.com> wrote:
>> Hi,
>>
>> On Mon, Sep 27, 2010 at 03:18:24PM -0500, Grazvydas Ignotas wrote:
>>>
>>> +static int twl4030_bci_usb_ncb(struct notifier_block *nb, unsigned long
>>> val,
>>> +                              void *priv)
>>> +{
>>> +       struct twl4030_bci *bci = container_of(nb, struct twl4030_bci,
>>> otg_nb);
>>> +
>>> +       dev_dbg(bci->dev, "OTG notify %lu\n", val);
>>> +
>>> +       switch (val) {
>>> +       case USB_EVENT_VBUS:
>>> +       case USB_EVENT_CHARGER:
>>
>> you should have removed CHARGER from here :-)
>
>hm why? Don't recall you commenting on that, why can't I charge from charger?

Charger event is SENT by charger driver when it verifies it's attached
to a wall charger.

-- 
balbi
