Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0JMRyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 13:54:12 -0400
Received: from mail.atheros.com ([12.19.149.2]:29426 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab0JMRyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 13:54:10 -0400
From: Kevin Hayes <kevin@Atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
        Marcel Holtmann <marcel@holtmann.org>
CC: Henry Ptasinski <henryp@broadcom.com>,
        Suraj Sumangala <Suraj.Sumangala@Atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 13 Oct 2010 10:54:08 -0700
Subject: RE: Firmware versioning best practices: ath3k-2.fw rename or
 replace ath3k-1.fw ?
Thread-Topic: Firmware versioning best practices: ath3k-2.fw rename or
 replace ath3k-1.fw ?
Thread-Index: Actq/jiG/dv708nJRdi9YM1vaAmvsgAAP8Rg
Message-ID: <B7132A25476D334D9130FE7532F2A56314B5929629@SC1EXMB-MBCL.global.atheros.com>
References: <20101008170258.GJ10149@tux> <4CAF5488.3030706@Atheros.com>
 <20101008181508.GM10149@tux> <20101012211726.GE2678@broadcom.com>
 <1286964370.3316.6.camel@aeonflux>
 <AANLkTimAeoS2Vi7GhKSTrghqaOQ=XKSzjcou15dn+YDR@mail.gmail.com>
In-Reply-To: <AANLkTimAeoS2Vi7GhKSTrghqaOQ=XKSzjcou15dn+YDR@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9DHsQVF002732

Hi Luis,


> -----Original Message-----
> From: linux-bluetooth-owner@vger.kernel.org [mailto:linux-bluetooth-
> owner@vger.kernel.org] On Behalf Of Luis R. Rodriguez
> Sent: Wednesday, October 13, 2010 10:43 AM
> To: Marcel Holtmann
> Cc: Henry Ptasinski; Suraj Sumangala; Luis Rodriguez; David Woodhouse;
> linux-bluetooth; linux-kernel@vger.kernel.org; linux-wireless
> Subject: Re: Firmware versioning best practices: ath3k-2.fw rename or
> replace ath3k-1.fw ?
> 
> On Wed, Oct 13, 2010 at 3:06 AM, Marcel Holtmann <marcel@holtmann.org>
> wrote:
> > Hi Henry,
> >
> >> > > Marcel had answered me before. It makes sense to have same file
> name.
> >> > > Other ways we end up changing the driver whenever there is a
> firmware
> >> > > change.
> >> >
> >> > > > I last tried to document a thread we had over this here:
> >> > > >
> >> > > >
> http://wireless.kernel.org/en/developers/Documentation/firmware-
> versioning
> >> > > >
> >> >
> >> > Thanks, I've updated that link above to document bug fixing does
> not require
> >> > a filename change.
> >>
> >> I don't really understand why you would not want to change the code
> revision
> >> part of the filename.
> >>
> >> I totally agree that you don't want to change the driver every time
> the
> >> firmware gets a bug fix, but wasn't that the whole point of
> splitting the name
> >> into API and code revisions portions, and symlinking the file to one
> that just
> >> has the API version?
> >>
> >> What's the issue with using the process as originally documented?
> >
> > as I stated before, for Bluetooth this makes no sense. You don't need
> > API version numbers since the API is a STANDARD. It is called HCI. So
> > please don't use API version numbers in the firmware files.
> >
> > I will reject firmware file versions for upstream drivers.
> 
> Does the HCI standard ever get improved upon? If so, how do devices
> never get firmware updates that would allow them to use some newer HCI
> APIs?
> 
> I've updated the documentation above for 802.11 and Bluetooth with the
> above, please feel free to further extend it as you see fit.
> 
>   Luis

HCI is always backward compatible.  Newer commands are properly discoverable by both sides of the HCI link.
As long as the procedure to download firmware does not depend on new HCI commands (it does not), then the firmware itself can teach an old controller to learn new tricks.

	K++
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
