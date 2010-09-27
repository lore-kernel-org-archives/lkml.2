Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab0I0Mfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:35:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51302 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095Ab0I0Mfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:35:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YPLPWlqSi27QGCav/uUTqYWX3HmfWS7x6IyVlFewvyrxYkphgEml78AYjYa6WO2Ude
         FZ436PNVC2XAGwz/HcsXt/LbKQAxWeNgQqN/d/jI0NjyvDEwlJtiB4avwBXtSq7BvHIR
         F1QH9bBDeGnzfx4QEicNoczJfEvZBBpHnCK6w=
MIME-Version: 1.0
In-Reply-To: <AANLkTinh+JTwyE4E33QXdnZ8obYA8S0SU71i3kGi=wRT@mail.gmail.com>
References: <1285529740-28232-1-git-send-email-notasas@gmail.com>
	<AANLkTinkxokX9BGtxysYOr19xbZR4S8oPRYUAyneutzc@mail.gmail.com>
	<AANLkTinh+JTwyE4E33QXdnZ8obYA8S0SU71i3kGi=wRT@mail.gmail.com>
Date: Mon, 27 Sep 2010 18:05:22 +0530
Message-ID: <AANLkTik0LOQN8kOPjv_VohhO5To6pZDS=M0mw=q0whPp@mail.gmail.com>
Subject: Re: [PATCH v3] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Arun Murthy <arunrmurthy.83@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Madhusudhan <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 4:24 PM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> On Mon, Sep 27, 2010 at 10:21 AM, Arun Murthy <arunrmurthy.83@gmail.com> wrote:
>> On Mon, Sep 27, 2010 at 1:05 AM, Grazvydas Ignotas <notasas@gmail.com>
>> wrote:
>>> ---
>> Only AC and USB monitoring is achieved by registering with power supply
>> class.
>> How is battery monitored?
>> An instance of battery is to be registered with power supply class in order
>> to monitor battery.
>
> The problem is that BCI is only active while charging, when it is not
> charging most (all?) monitoring registers freeze and no monitoring
> happens (BCI registers read frozen values from last charge). So I
> don't register battery as it has no useful data to report. I heard it
> is possible to use MADC to perform monitoring while not charging, so
> battery can be added when MADC driver is merged and corresponding code
> is written for this driver.
>
How do I check the battery voltage?
I need to check the battery voltage/current/temp and, if I am not
wrong these are obtained from MADC.
MADC driver has to be added first and then the battery.
With being able to read the basic parameter battery voltage, this
driver becomes incomplete.

How do I get notified if battery voltage is low and needs charging
from user space?

Thanks and Regards,
Arun R Murthy
---------------------
