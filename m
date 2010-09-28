Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785Ab0I1Iht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:37:49 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45350 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab0I1Ihr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dATf61Y1o/kpkt9BRs/KLVHuiYHs69k2lfIuUKSZ5ajH4vs5w9C0V8sVGRSzY96WuX
         LIONI9U4Oholb0z1Q7ogcnl07URMEmybsKsNt7/Rh/8pew3GQeVRbo6MGjzDoMP1CO/N
         9+EkT6/7S2jusBioKoHiEizq3/eEVf48hg49c=
MIME-Version: 1.0
In-Reply-To: <20100928060554.GF2702@legolas.emea.dhcp.ti.com>
References: <1285618704-8985-1-git-send-email-notasas@gmail.com>
	<20100928060554.GF2702@legolas.emea.dhcp.ti.com>
Date: Tue, 28 Sep 2010 11:37:46 +0300
Message-ID: <AANLkTikZqtXa2YQsDehoWVMRstefUyafsQn2mph7U3CZ@mail.gmail.com>
Subject: Re: [PATCH v4] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Grazvydas Ignotas <notasas@gmail.com>
To: balbi@ti.com
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 9:05 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Sep 27, 2010 at 03:18:24PM -0500, Grazvydas Ignotas wrote:
>>
>> +static int twl4030_bci_usb_ncb(struct notifier_block *nb, unsigned long
>> val,
>> +                              void *priv)
>> +{
>> +       struct twl4030_bci *bci = container_of(nb, struct twl4030_bci,
>> otg_nb);
>> +
>> +       dev_dbg(bci->dev, "OTG notify %lu\n", val);
>> +
>> +       switch (val) {
>> +       case USB_EVENT_VBUS:
>> +       case USB_EVENT_CHARGER:
>
> you should have removed CHARGER from here :-)

hm why? Don't recall you commenting on that, why can't I charge from charger?
