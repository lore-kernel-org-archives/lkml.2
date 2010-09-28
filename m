Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0I1Nd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:33:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47644 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab0I1Ndz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:33:55 -0400
Date: Tue, 28 Sep 2010 16:33:45 +0300
From: Felipe Balbi <balbi@ti.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "Balbi, Felipe" <balbi@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
        Arun Murthy <arunrmurthy.83@gmail.com>
Subject: Re: [PATCH v4] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20100928133345.GA8575@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1285618704-8985-1-git-send-email-notasas@gmail.com>
 <20100928060554.GF2702@legolas.emea.dhcp.ti.com>
 <AANLkTikZqtXa2YQsDehoWVMRstefUyafsQn2mph7U3CZ@mail.gmail.com>
 <20100928084251.GC3900@legolas.emea.dhcp.ti.com>
 <AANLkTin-6BLBHeiyA1edTJVjwVAimmJLVicZj8c_VC_2@mail.gmail.com>
 <20100928090637.GD3900@legolas.emea.dhcp.ti.com>
 <AANLkTim28RmH28LGgp6bEJ7XbyL4oO_5_C0phLL86roY@mail.gmail.com>
 <20100928094122.GA7081@legolas.emea.dhcp.ti.com>
 <20100928112643.GC22734@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100928112643.GC22734@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 06:26:43AM -0500, Anton Vorontsov wrote:
>On Tue, Sep 28, 2010 at 12:41:22PM +0300, Felipe Balbi wrote:
>> On Tue, Sep 28, 2010 at 04:39:17AM -0500, Grazvydas Ignotas wrote:
>> >On Tue, Sep 28, 2010 at 12:06 PM, Felipe Balbi <balbi@ti.com> wrote:
>> >>On Tue, Sep 28, 2010 at 04:02:48AM -0500, Grazvydas Ignotas wrote:
>> >>>>
>> >>>>Charger event is SENT by charger driver when it verifies it's attached
>> >>>>to a wall charger.
>> >>>
>> >>>Isn't that a job for musb/gadget? Detecting D+/D- being shorted by
>> >>>charger or something like that? I don't think BCI is able to detect
>> >>>charger.
>> >>
>> >>it's part of the charger detection right ? and according to trm, it's on
>> >>the BCI (actually BCC) role to take care of that :-)
>> >
>> >Hm you are probably talking about TWL5031, which has redesigned
>> >charger block that is named BCC. TWL4030 charger is different, called
>> >BCI and requires software charger detection from what I see in it's
>> >TRM.
>>
>> ok, might be that I got confused. Then it's ok the way it is. So we need
>> other means to detect the charger :-p
>
>May we consider this as a minor issue that can be improved later?

Sure, it's fine.

>If so, I would like to apply it, but I'll wait a day or two for
>Reviewed-by or Acked-by tags to give the proper credits.

Here you go.

Acked-by: Felipe Balbi <balbi@ti.com>

-- 
balbi
